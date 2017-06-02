ENV["RACK_ENV"] ||= "development"

require 'sinatra'
require 'sinatra/flash'
require_relative 'data_mapper_setup'
require 'link_thumbnailer'

class BookmarkManager < Sinatra::Base

  register Sinatra::Flash

  enable :sessions
  set :session_secret, 'makers'

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

  get '/' do
    @user = current_user
    erb :index
  end
  
  get '/links' do
    current_user
    @links = Link.all(:order => [:title.asc])
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new'
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links(:order => [:title.asc]) : []
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

  get '/links/delete/:id' do
    link = Link.get(params[:id])
    link.destroy!
    redirect to('/links')
  end

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end

  post '/users' do
    @user = User.new(email: params[:email],
                     password: params[:password])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/')
    else
      flash.now[:notice] = "Error - Account was not created"
      erb :'users/new'
    end
  end
end
