require 'sinatra'
require 'active_record'
require 'pry'

###########################################################
# Configuration
###########################################################

set :public_folder, File.dirname(__FILE__) + '/public'

configure :development, :production do
    ActiveRecord::Base.establish_connection(
       :adapter => 'sqlite3',
       :database =>  'db/dev.sqlite3.db'
     )
end

# Handle potential connection pool timeout issues
after do
    ActiveRecord::Base.connection.close
end

###########################################################
# Models
###########################################################
# Models to Access the database through ActiveRecord.
# Define associations here if need be
# http://guides.rubyonrails.org/association_basics.html

class Link < ActiveRecord::Base
end

###########################################################
# Routes
###########################################################

get '/' do
  puts Link.find(:all).to_s
  @links = Link.find :all
  erb :index
end

get '/new' do
    erb :form
end

post '/new' do
  url = params[:url]
  if !(Link.find_by_url(url)) then
    shortURL = shortenURL
    while(Link.find_by_code(shortURL))
      shortURL = shortenURL
    end
    newLink = Link.create({:url => url, :code => shortURL})
  end
  # redirect :index
end

get '/:code' do
  # link = Link.find(params[:code])
  # redirect link.url
end

def shortenURL
  shortURL = Random.new.rand(65..90).chr + Random.new.rand(65..90).chr
end

# MORE ROUTES GO HERE