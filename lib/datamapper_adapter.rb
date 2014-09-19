module DataMapperAdapter

  # Implement the interface for fetching records
  #
  module Records
    def records
      sql_records = klass.all(id: @ids)
      # Re-order records based on the order from Elasticsearch hits
      # by redefining `to_a`, unless the user has called `order()`
      #
      sql_records.instance_exec(response.response['hits']['hits']) do |hits|
        define_singleton_method :to_a do
          @records.sort_by { |record| hits.index { |hit| hit['_id'].to_s == record.id.to_s } }
        end
      end
      sql_records
    end

    # Intercept call to the `order` method, so we can ignore the order from Elasticsearch
    #
    def order(*args)
      sql_records = records.__send__ :order, *args
    end
  end

  module Callbacks
    # Handle index updates (creating, updating or deleting documents)
    # when the model changes, by hooking into the lifecycle
    #
    # @see http://guides.rubyonrails.org/active_record_callbacks.html
    #
    def self.included(base)
      base.class_eval do
        after :create do
          __elasticsearch__.index_document
        end
        after :update do
          __elasticsearch__.update_document
        end
        after :destroy do
          __elasticsearch__.delete_document
        end
        # after_commit lambda { __elasticsearch__.delete_document }, on: :destroy
      end
    end
  end

  module Importing
    def __find_in_batches(options={}, &block)
      query = options.delete(:query)
      named_scope = options.delete(:scope)
      preprocess = options.delete(:preprocess)
      scope = self
      scope = scope.__send__(named_scope) if named_scope
      scope = scope.instance_exec(&query) if query
      per_batch = options.values.try(:first)
      per_batch ||= 1000
      scope.each_chunk(per_batch) do |batch|
        yield (preprocess ? self.__send__(preprocess, batch) : batch)
      end
    end
    def __transform
      lambda { |model| { index: { _id: model.id, data: model.__elasticsearch__.as_indexed_json } } }
    end
  end
end

# class DataMapper::Collection
#   def batch(n)
#     Enumerator.new do |y|
#       offset = 0
#       loop do 
#         records = slice(offset, n)
#         break if records.empty?
#         records.each { |record| y.yield(record) }
#         offset += records.size
#       end
#     end
#   end
# end


# Register the adapter
#
Elasticsearch::Model::Adapter.register(
  DataMapperAdapter,
  lambda { |klass| defined?(::DataMapper::Resource) and klass.ancestors.include?(::DataMapper::Resource) }
)