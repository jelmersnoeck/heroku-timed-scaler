class Scheduler
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

    formation = scaler.current_scale
    slot.set_initial_values(formation["size"].downcase, formation["quantity"])

    scaler.scale_to(slot.formation_size, slot.formation_quantity)

    Scheduler.delay_until(@slot.to).reset(@slot.id)
  end

  def reset!
    return false if !@slot.resetable?

    scaler.scale_to(slot.formation_initial_size, slot.formation_initial_quantity)
  end

  private

  def slot
    @slot
  end

  def scaler
    @_scaler ||= Scaler.new(app_name, slot.formation_type)
  end

  def app_name
    ENV['HEROKU_APP_NAME']
  end
end
