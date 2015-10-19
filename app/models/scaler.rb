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

    formation = heroku.formation.info(app_name, slot.formation_type)
    slot.set_initial_values(formation["size"].downcase, formation["quantity"])
    heroku.formation.update(app_name, slot.formation_type, {
      quantity: slot.formation_quantity,
      size: slot.formation_size
    })
  end

  def reset!
    return false if !@slot.resetable?

    heroku.formation.update(app_name, slot.formation_type, {
      quantity: slot.formation_initial_quantity,
      size: slot.formation_initial_size
    })
  end

  private
  def heroku
    @_heroku ||= PlatformAPI.connect_oauth(ENV['HEROKU_OAUTH'])
  end

  def slot
    @slot
  end

  def app_name
    ENV['HEROKU_APP_NAME']
  end
end
