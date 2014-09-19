=begin
module DataMapperAdapter
  # Implement the interface for fetching records
  #
  module Records
    def records
      klass.all(id: @ids)
    end
  # ...
  end
end
# Register the adapter
#
Elasticsearch::Model::Adapter.register(
  DataMapperAdapter,
  lambda { |klass| defined?(::DataMapper::Resource) and klass.ancestors.include?(::DataMapper::Resource) }
)
=end
