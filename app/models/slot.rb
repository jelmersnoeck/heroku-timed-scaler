class Slot < ActiveRecord::Base
  FORMATION_SIZES = ['free', 'hobby', 'standard-1x', 'standard-2x',
                     'performance-m', 'performance-l'].freeze

  ### Enums
  enum formation_size: FORMATION_SIZES

  ### Validation
  validates :from, :to, :formation_size, :formation_type, :formation_quantity,
    presence: true
  validates :formation_quantity, numericality: { greater_than: 0 }

  ### Scopes
  scope :scheduled, -> {
    where("slots.to > ? ", Time.now())
  }

  def cancel!
    self.update_attributes(cancelled: true)
  end

  def active?
    from <= Time.now && to >= Time.now
  end
end
