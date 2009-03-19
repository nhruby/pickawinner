require "#{File.dirname(__FILE__)}/spec_helper"

describe 'main application' do
  include Sinatra::Test

  before(:each) do
    @contest = mock('contest', :name => 'contest', :null_object => true)
  end

  context 'index' do
    before(:each) do
      Contest.stub!(:all).and_return([@contest])
    end

    specify 'should show the default index page' do
      get '/'
      @response.should be_ok
      @response.body.should match(/Recent Contests/)
    end

    specify 'should show all recent contests' do
      get '/'
      @response.body.should have_tag('li', /#{@contest.name}/, :count => 1)
    end
  end

  context 'new' do
    specify 'should show the new contest form' do
      get '/contests/new'
      @response.should be_ok
      @response.should have_tag('form[@action=/contests]')
    end
  end

  context 'create' do
    before(:each) do
      Contest.should_receive(:new).and_return(@contest)
    end

    specify 'should create a new contest' do
      @contest.should_receive(:save).and_return(true)
      post '/contests', :name => 'new contest name', :contestants => 'pidge, lance, keith'
    end

    specify 'should redirect to show contest winner' do
      @contest.should_receive(:save).and_return(true)
      post '/contests', :name => 'new contest name', :contestants => 'pidge, lance, keith'
      @response.should be_redirect
    end

    specify 'should re-render the new form if there is an error' do
      @contest.should_receive(:save).and_return(false)
      post '/contests', :name => 'new contest name', :contestants => 'pidge, lance, keith'
      @response.body.should have_tag('form[@action=/contests]')
    end
  end

  context 'show' do
    before(:each) do
      @contest.stub!(:winner).and_return('winner')
      Contest.stub!(:get).and_return(@contest)
    end
    specify 'should retrieve the requested contest information' do
      Contest.should_receive(:get)
      get '/contests/1'
    end

    specify 'should show contest results' do
      get '/contests/1'
      @response.should be_ok
      @response.should have_tag('p', /#{@contest.winner}/)
    end
  end
end
