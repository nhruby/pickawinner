require "#{File.dirname(__FILE__)}/spec_helper"

describe 'contest' do
  before(:each) do
    @contest = Contest.new(:name => 'test user', :contestants => ['pidge', 'keith', 'lance'])
  end

  specify 'should be valid' do
    @contest.should be_valid
  end

  specify 'should require a name' do
    @contest = Contest.new
    @contest.save.should be_false
    @contest.errors[:name].should include("Name must not be blank")
  end

  specify 'should require some contestants' do
    @contest = Contest.new
    @contest.save.should be_false
    @contest.errors[:contestants].should include("Contestants must not be blank")
  end

  specify 'should select a winner' do
    @contest.save
    @contest.winner.should_not be_nil
  end
end
