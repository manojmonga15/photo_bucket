module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    settings index: { number_of_shards: 1 }
    def as_indexed_json
      self.as_json({
        only: [:id, :comment],
        include: {
          picture: { only: [:id, :title, :description] },
        }
      })
    end
  end
end
