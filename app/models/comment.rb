require 'elasticsearch/model'
require 'datamapper_adapter'
class Comment
  include DataMapper::Resource
  include DataMapper::MassAssignmentSecurity 
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  attr_accessible :comment, :picture, :user

  property :id, Serial
  property :comment, Text, required: true

  belongs_to :picture
  belongs_to :user

  settings index: { number_of_shards: 1 }
  def as_indexed_json(options = {})
    self.as_json({
      only: [:id, :comment],
      relationships: {
        picture: {only: [:id, :title, :description]},
        user: {only: :name}
      }
    })
  end
end
