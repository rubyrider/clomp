RSpec.describe ServiceObject::Operation do
  describe 'Successful operation' do
    class SuccessfulOperation < ServiceObject::Operation
      track :first_track
    
      track :call_something do |options|
        options[:d] = 'New'
      end
    
      failure :notify_admin
      finally :tell_user_about_this
    
      def first_track(options, mutable_data: , **)
        mutable_data[:c] = 'Updated'
      end
    
      def call_something(options)
      end
    
      def notify_admin(options)
      end
    
      def tell_user_about_this(options)
      end
    end
  
    before do
      @result = SuccessfulOperation.({a: 1}, {b: 2})
    end
  
    it 'Operation#success? should return false if all the steps are successful' do
      expect(@result.success?).to be_truthy
    end
  
    it 'should add tracks' do
      expect(@result.steps).to include :first_track
      expect(@result.steps).to include :call_something
      expect(@result.steps).to include :notify_admin
      expect(@result.steps).to include :tell_user_about_this
    end
  
    it 'should mutate options' do
      expect(@result.options[:mutable_data][:c]).to be == 'Updated'
    end
  
    it 'should execute block on success' do
      expect(@result.options[:d]).to be == 'New'
    end
  end

  describe 'Failure operation' do
    class FailureOperation < ServiceObject::Operation
      track :first_track
    
      track :call_something do |options|
        options[:d] = 'New'
      end
    
      failure :notify_admin
      finally :tell_user_about_this
    
      def first_track(options, mutable_data: , **)
        mutable_data[:c] = 'Updated'
      end
    
      def call_something(options)
        false
      end
    
      def notify_admin(options) end
    
      def tell_user_about_this(options) end
    end
  
    before do
      @result = FailureOperation.({a: 1}, {b: 2})
    end
  
    it 'Operation#failure? should return true if any step is failure' do
      expect(@result.success?).to be_falsey
      expect(@result.failure?).to be_truthy
    end
  
    it 'should add tracks' do
      expect(@result.steps).to include :first_track
      expect(@result.steps).to include :call_something
    end
  
    it 'should not call steps after the failed track' do
      expect(@result.executed_steps).not_to include :notify_admin
      expect(@result.executed_steps).not_to include :tell_user_about_this
    end
  
    it 'should mutate options' do
      expect(@result.options[:mutable_data][:c]).to be == 'Updated'
    end
  
    it 'should execute block on success' do
      expect(@result.options[:d]).to be_nil
    end
  end
end
