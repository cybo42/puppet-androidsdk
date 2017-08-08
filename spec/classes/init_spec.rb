require 'spec_helper'
describe 'androidsdk' do

  context 'with defaults for all parameters' do
    it { should contain_class('androidsdk') }
  end
end
