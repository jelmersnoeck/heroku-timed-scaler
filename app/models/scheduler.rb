class Scheduler
  ### Class methods
  def self.schedule(time, type = :up)
    Scheduler.delay_until(time + Scheduler.delay(type))
  end

  def self.scale(id)
    new(Slot.find(id)).scale!
  end

  def self.reset(id)
    new(Slot.find(id)).reset!
  end

  def self.delay(type = :up)
    scaling_time = 0
    if !ENV['SCALING_TIME'].blank?
      scaling_time = ENV['SCALING_TIME'].to_i
    end

    # If we're scaling up, we want to scale before the actual time
    scaling_time = scaling_time * -1 if type == :up
    scaling_time.minutes
  end

  ### Instance methods
  def initialize(slot)
    @slot = slot
  end

  def scale!
    return false if !@slot.scaleable?

    formation = scaler.current_scale
    scaler.scale_to(slot.formation_size, slot.formation_quantity)

    slot.set_initial_values(formation["size"].downcase, formation["quantity"])

    Scheduler.schedule(@slot.to, :down).reset(@slot.id)
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
