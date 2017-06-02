ENV["RACK_ENV"] ||= "development"

require 'sinatra'
require_relative 'data_mapper_setup'
require 'link_thumbnailer'

class BookmarkManager < Sinatra::Base

  get '/' do
    erb :index
  end
  
  get '/links' do
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
    p params
    scrape = LinkThumbnailer.generate(params[:url], redirect_limit: 5, user_agent: 'foo')
    link = Link.create(url: params[:url], title: params[:title], description: scrape.description, image: scrape.images.first.src.to_s)
    params[:tags].split(',').each do |tag|
      link.tags << Tag.first_or_create(name: tag)
    end
    link.save
    redirect to('/links')
  end

  get '/links/delete/:id' do
    p link = Link.get(params[:id])
    p link.destroy!
    redirect to('/links')
  end

end
