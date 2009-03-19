require 'rubygems'
require 'sinatra'
require 'environment'

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
end

error do
  e = request.env['sinatra.error']
  puts e.to_s
  puts e.backtrace.join('\n')
  'Application error'
end

helpers do
  def contest_url(contest)
    "/contests/#{contest.id}"
  end
end

# index
['/', '/contests'].each do |action|
  get action do
    @contests = Contest.all(:order => [:created_at.desc])
    erb :index
  end
end

# new
get '/contests/new' do
  @contest = Contest.new
  erb :new
end

# create
post '/contests' do
  @contest = Contest.new(:name => params[:name])
  @contest.contestants = (params[:contestants] || '').split(',').map { |s| s.strip }
  if @contest.save
    redirect contest_url(@contest)
  else
    erb :new
  end
end

# show
get '/contests/:id' do
  @contest = Contest.get(params[:id])
  erb :show
end
