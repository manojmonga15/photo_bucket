class Picture

  include DataMapper::Resource
  include DataMapper::MassAssignmentSecurity
  include DataMapper::Validate
  include Paperclip::Resource

  attr_accessible :title, :description, :avatar
  property :id, Serial
  property :title, String, required: true
  property :description, String
 
  has_attached_file :avatar,
                    styles: { medium: "550x415>",
                              thumb: "180x180>" }

  validates_attachment_size :avatar, in: 1..1048576

  belongs_to :user
  has n, :comments
end
