RSpec.describe TheRailway::Operation do
  class TestOperation < TheRailway::Operation
    add_track :first_track
    add_track :call_something
    
    def first_track(options, mutable_data: , **)
      mutable_data[:c] = 'Updated'
    end
    
    def call_something(options)
      puts options[:mutable_options]
    end
  end
  
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
end

