class Scaler
  def initialize(app_name, type)
    @app_name, @type = app_name, type
  end

  def scale_to(type, size, quantity)
    heroku.formation.update(@app_name, @type, { size: size, quantity: quantity })
  end

  def current_scale
    heroku.formation.info(@app_name, @type)
  end

  private
  def heroku
    @_heroku ||= PlatformAPI.connect_oauth(ENV['HEROKU_OAUTH'])
  end
end
