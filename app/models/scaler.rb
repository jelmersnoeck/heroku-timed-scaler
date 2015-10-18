class Scaler
  ### Class methods
  def self.scale(id)
    new(Slot.find(id)).scale!
  end

  def self.reset(id)
    new(Slot.find(id)).reset!
  end

  ### Instance methods
  def initialize(slot)
    @slot = slot
  end

  def scale!
    return false if !@slot.scaleable?
    Scaler.delay_until(@slot.to).reset(@slot.id)

    # Get current scale
    # Save current scale on slot
    # Scale Heroku
  end

  def reset!
    return false if !@slot.resetable?

    # Scale Heroku
  end
end
