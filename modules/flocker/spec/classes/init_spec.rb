require 'spec_helper'
describe 'flocker' do

  context 'with defaults for all parameters' do
    it { should contain_class('flocker') }
  end
end
