class Slot < ActiveRecord::Base
  FORMATION_SIZES = ['free', 'hobby', 'standard-1x', 'standard-2x',
                     'performance-m', 'performance-l'].freeze

  ### Enums
  enum formation_size: FORMATION_SIZES

  ### Validation
  validates :from, :to, :formation_size, :formation_type, :formation_quantity,
    presence: true
  validates :formation_quantity, numericality: { greater_than: 0 }
  validate :unique_type_period, on: :create
  validate :correct_size_quantity

  ### Scopes
  scope :scheduled, -> {
    where("slots.to > ? ", Time.now())
  }

  ### Callbacks
  after_commit :schedule!, on: :create

  ### Instance methods
  def cancel!
    self.update_attributes(cancelled: true)
  end

  def set_initial_values(size, quantity)
    self.update_attributes(
      formation_initial_size: size,
      formation_initial_quantity: quantity
    )
  end

  def active?
    from <= Time.now && to >= Time.now
  end

  def deletable?
    !cancelled? && !active?
  end

  def scaleable?
    Time.now >= from && Time.now < to && formation_initial_size.nil? &&
      formation_initial_quantity.nil?
  end

  def resetable?
    Time.now >= to && !formation_initial_size.nil? &&
      !formation_initial_quantity.nil?
  end

  def schedule!
    Scheduler.schedule(from).scale(id)
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

  def correct_size_quantity
    if ['free', 'hobby'].include?(formation_size) && formation_quantity > 1
      errors.add(:formation_quantity, "can only be 1 for #{formation_size}.")
    end
  end
end
