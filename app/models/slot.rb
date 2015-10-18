class Slot < ActiveRecord::Base
  FORMATION_SIZES = ['free', 'hobby', 'standard-1x', 'standard-2x',
                     'performance-m', 'performance-l'].freeze

  ### Enums
  enum formation_size: FORMATION_SIZES

  ### Validation
  validates :from, :to, :formation_size, :formation_type, presence: true
end
