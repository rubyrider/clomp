RSpec.describe ServiceObject do
  it 'has a version number' do
    expect(ServiceObject::VERSION).not_to be '0.1.0'
  end
end
