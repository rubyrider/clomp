RSpec.describe Clomp::Operation do
  describe 'Successful operation' do
    class AnotherOperation < Clomp::Operation
      step :track_from_another_operation
      
      def track_from_another_operation(options)
        options[:hello_from_another_operation] = true
      end
    end
    
    class SuccessfulOperation < Clomp::Operation
      track :first_track
      
      share :track_from_another_operation, from: 'AnotherOperation'
      
      track :call_something do |options|
        options[:d] = 'New'
      end
      
      failure :notify_admin
      finally :tell_user_about_this
      
      def first_track(options, params:, **)
        params[:c] = 'Updated'
      end
      
      def call_something(options)
        # call something
        true
      end
      
      def notify_admin(options)
        # notify someone
      end
      
      def tell_user_about_this(options)
        # do something else
      end
    end
    
    before do
      @result = SuccessfulOperation[a: 1]
    end
    
    it 'Operation#success? should return false if all the steps are successful' do
      expect(@result.success?).to be_truthy
    end
    
    it 'should have configuration' do
      expect(@result.configs).to be_an_instance_of(Clomp::Configuration)
    end
    
    it 'should configured to fail fast' do
      expect(@result.configs.fail_fast).to be_falsey
    end
    
    it 'should configured to pass fast' do
      expect(@result.configs.pass_fast).to be_falsey
    end
    
    it 'should configured to execute track optionally' do
      # Failure step wont count as failure, just ignoring the output
      expect(@result.configs.optional).to be_falsey
    end
    
    it 'should add tracks' do
      expect(@result.steps).to include :first_track
      expect(@result.steps).to include :call_something
      expect(@result.steps).to include :notify_admin
      expect(@result.steps).to include :tell_user_about_this
    end
    
    it 'should mutate options' do
      expect(@result.options[:params][:c]).to be == 'Updated'
    end
    
    it 'should execute block on success' do
      expect(@result.options[:d]).not_to be_nil
    end
    
    it 'should get effective from another operation' do
      expect(@result.options[:hello_from_another_operation]).to be_truthy
    end
  end
  
  describe 'Failure operation' do
    context 'without fail fast' do
      class FailureOperation < Clomp::Operation
        set :first_track
        
        track :call_something do |options|
          options[:d] = 'New'
        end
        
        failure :notify_admin
        finally :tell_user_about_this
        
        def first_track(options, params:, **)
          params[:c] = 'Updated'
        end
        
        def call_something(options)
          false
        end
        
        def notify_admin(options)
        end
        
        def tell_user_about_this(options)
        end
      end
      
      
      before do
        @result = FailureOperation[{ a: 1 }, { b: 2 }]
      end
      
      it 'should have configuration' do
        expect(@result.configs).to be_an_instance_of(Clomp::Configuration)
      end
      
      it 'should be configured not to fail fast by default' do
        expect(@result.configs.fail_fast).to be_falsey
      end
      
      it 'should be configured not to pass fast by default' do
        expect(@result.configs.pass_fast).to be_falsey
      end
      
      it 'should be configured not to execute track optionally' do
        expect(@result.configs.optional).to be_falsey
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
    end
    
    context "With fail fast" do
      class User; end
      
      class FailFastOperation < Clomp::Operation
        set :first_track
        
        track :call_something, track_options: { fail_fast: true } do |options|
          options[:current_user] = User.new
        end
        
        failure :notify_admin
        finally :tell_user_about_this
        
        def first_track(options, params:, **)
          params[:c] = 'Updated'
        end
        
        def call_something(options)
          false
        end
        
        def notify_admin(options)
        end
        
        def tell_user_about_this(options)
        end
      end
      
      
      before do
        @result = FailFastOperation[{ a: 1 }, { b: 2 }]
      end
      
      it 'should have configuration' do
        expect(@result.configs).to be_an_instance_of(Clomp::Configuration)
      end
      
      it 'should be configured not to fail fast by default' do
        expect(@result.configs.fail_fast).to be_falsey
      end
      
      it 'should be configured not to pass fast by default' do
        expect(@result.configs.pass_fast).to be_falsey
      end
      
      it 'should be configured not to execute track optionally' do
        expect(@result.configs.optional).to be_falsey
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
        # Because of fail fast at the first track!
        expect(@result.options[:params][:c]).to be_nil
      end
      
      it 'should execute block on failure' do
        # Because of fail fast at the first track!
        expect(@result.options[:current_user]).to be_nil
      end
    end
  end
end
