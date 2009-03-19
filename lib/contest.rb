class Contest
  include DataMapper::Resource

  property :id,          Serial
  property :name,        String  
  property :created_at,  DateTime
  property :updated_at,  DateTime
  property :contestants, Csv
  property :winner,      String

  validates_present :name, :contestants

  before :save do
    choose_winner
  end

  private

  def choose_winner
    self.winner = contestants[rand(contestants.length)]
  end
end
