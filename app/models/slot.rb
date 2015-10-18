class Slot < ActiveRecord::Base
  FORMATION_SIZES = ['free', 'hobby', 'standard-1x', 'standard-2x',
                     'performance-m', 'performance-l'].freeze

  ### Enums
  enum formation_size: FORMATION_SIZES

  ### Validation
  validates :from, :to, :formation_size, :formation_type, :formation_quantity,
    presence: true
  validates :formation_quantity, numericality: { greater_than: 0 }
  validate :unique_type_period

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

  private
  def unique_type_period
    from_check = Slot.where(from: from..to, formation_type: formation_type).any?
    to_check = Slot.where(to: from..to, formation_type: formation_type).any?
    check = Slot.where(
      "slots.from <= ? AND slots.to >= ? AND slots.formation_type = ?",
      from,
      to,
      formation_type
    ).any?

    if from_check || to_check || check
      errors.add(:base, "There is already an active slot within the given time for this formation type.")
    end
  end
end
