class Link

  include DataMapper::Resource

  has n, :tags, through: Resource

  property :id,          Serial
  property :title,       String
  property :url,         String
  property :description, String, :length => 500
  property :image,       String, :length => 500

end
