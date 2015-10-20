require "rails_helper"

RSpec.describe Scaler do
  before do
    @formation = double(PlatformAPI::Formation)
    api = double(PlatformAPI, formation: @formation)
    allow(PlatformAPI).to receive(:connect_oauth).with(ENV['HEROKU_OAUTH']).
      and_return(api)

    @scaler = Scaler.new('my-app', 'web')
  end

  describe "#scale_to" do
    it "should update the formation with the specified size and quantity" do
      options = {
        size: 'standard-1x',
        quantity: 3
      }

      expect(@formation).to receive(:update).once.
        with('my-app', 'web', options)

      @scaler.scale_to('standard-1x', 3)
    end
  end

  describe "#current_scale" do
    it "should get the current formation type information" do
      expect(@formation).to receive(:info).once.
        with('my-app', 'web')

      @scaler.current_scale
    end
  end
end
