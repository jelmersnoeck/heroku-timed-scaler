class Slot < ActiveRecord::Base
  FORMATION_SIZES = ['free', 'hobby', 'standard-1x', 'standard-2x',
                     'performance-m', 'performance-l'].freeze

  ### Enums
  enum formation_size: FORMATION_SIZES

  ### Validation
  validates :from, :to, :formation_size, :formation_type, presence: true

  ### Scopes
  scope :scheduled, -> {
    where("slots.to > ? ", Time.now())
  }

  def cancel!
    self.update_attributes(cancelled: true)
  end
end
