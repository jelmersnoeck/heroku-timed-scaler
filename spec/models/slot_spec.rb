require 'rails_helper'

RSpec.describe Slot, type: :model do
  it { should validate_presence_of(:from) }
  it { should validate_presence_of(:to) }
  it { should validate_presence_of(:formation_size) }
  it { should validate_presence_of(:formation_type) }
end
