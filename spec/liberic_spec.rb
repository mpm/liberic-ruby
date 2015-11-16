require 'spec_helper'

describe Liberic do
  it 'has a version number' do
    expect(Liberic::VERSION).not_to be nil
  end

  it 'has an eric library version' do
    expect(Liberic::REQUIRED_LIBERICAPI_VERSION).not_to be nil
  end
end
