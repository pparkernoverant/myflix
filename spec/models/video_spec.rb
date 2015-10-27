require 'spec_helper'

describe Video do
  it { should have_and_belong_to_many :categories }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
end