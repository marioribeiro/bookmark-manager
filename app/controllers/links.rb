class BookmarkManager < Sinatra::Base

  get '/' do
    @user = current_user
    erb :index
  end

  get '/links' do
    current_user
    @links = Link.all(:order => [:title.asc])
    erb :'links/index'
  end

  post '/links' do
    scrape = LinkThumbnailer.generate(params[:url], redirect_limit: 5, user_agent: 'foo')
    link = Link.create(url: params[:url], title: params[:title], description: scrape.description, image: scrape.images.first.src.to_s)
    params[:tags].split(',').each do |tag|
      link.tags << Tag.first_or_create(name: tag)
    end
    link.save
    redirect to('/links')
  end
  
  get '/links/new' do
    erb :'links/new'
  end

  get '/links/delete/:id' do
    link = Link.get(params[:id])
    link.destroy!
    redirect to('/links')
  end
  
end