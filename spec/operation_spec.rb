RSpec.describe TheRailway::Operation do
  before do
    @operation = TestOperation.({a: 1}, {b: 2})
  end

  it 'should add tracks' do
    expect(@operation.steps).to include :first_track
    expect(@operation.steps).to include :call_something
  end
  
  it 'should mutate options' do
    expect(@operation.options[:mutable_data][:c]).to be == 'Updated'
  end
  
  it 'block should be executed' do
    expect(@operation.options[:d]).to be == "New"
  end
end

class TestOperation < TheRailway::Operation
  track :first_track
  
  track :call_something do |options|
    puts options[:d] = "New"
  end
  
  failure :notify_admin
  finally :tell_user_about_this
  
  def first_track(options, mutable_data: , **)
    mutable_data[:c] = 'Updated'
  end
  
  def call_something(options) end
  
  def notify_admin(options) end
  
  def tell_user_about_this(options) end
end
