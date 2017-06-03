class BookmarkManager < Sinatra::Base

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links(:order => [:title.asc]) : []
    erb :'links/index'
  end

end
