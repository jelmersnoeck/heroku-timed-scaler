require "rails_helper"

RSpec.describe Scheduler do
  before do
    @slot = FactoryGirl.build_stubbed(:slot)
    allow(Slot).to receive(:find).and_return(@slot)
  end

  describe ".scale" do
    it "should initiate a new instance and scale" do
      scheduler = double(Scheduler)
      expect(scheduler).to receive(:scale!)
      expect(Scheduler).to receive(:new).with(@slot).and_return(scheduler)

      Scheduler.scale(@slot.id)
    end
  end

  describe ".reset" do
    it "should initiate a new instance and reset" do
      scheduler = double(Scheduler)
      expect(scheduler).to receive(:reset!)
      expect(Scheduler).to receive(:new).with(@slot).and_return(scheduler)

      Scheduler.reset(@slot.id)
    end
  end

  describe ".schedule" do
    describe "without env set" do
      it "should pass through the time" do
        date = 1.day.from_now

        expect(Scheduler).to receive(:delay_until).with(date)
        Scheduler.schedule(date)
      end
    end

    describe "with env set" do
      before do
        ENV['SCALING_TIME'] = '5'
      end

      after do
        ENV['SCALING_TIME'] = nil
      end

      it "should pass through the time with scaling time added" do
        date = 1.day.from_now

        expect(Scheduler).to receive(:delay_until).with(date + 5.minutes)
        Scheduler.schedule(date)
      end
    end
  end

  describe "#scale!" do
    before do
      @scheduler = Scheduler.new(@slot)
    end

    describe "without scaleable slot" do
      before do
        expect(@slot).to receive(:scaleable?).and_return(false)
      end

      it "should return false" do
        expect(@scheduler.scale!).to be false
      end
    end

    describe "with scaleable slot" do
      before do
        expect(@slot).to receive(:scaleable?).and_return(true)

        @scaler = double(Scaler)
        allow(@scheduler).to receive(:scaler).and_return(@scaler)

        @current = {
          "size" => "Free",
          "quantity" => 3
        }
      end

      it "should set the initial values" do
        expect(@scaler).to receive(:current_scale).once.and_return(@current)
        expect(@slot).to receive(:set_initial_values).once.with("free", 3)

        expect(@scaler).to receive(:scale_to).once.with(
          @slot.formation_size,
          @slot.formation_quantity
        )

        scheduler = double(Scheduler)
        expect(scheduler).to receive(:reset).once.with(@slot.id)
        expect(Scheduler).to receive(:schedule).and_return(scheduler)

        @scheduler.scale!
      end
    end
  end

  describe "#reset!" do
    before do
      @slot.formation_initial_size = "standard-2x"
      @slot.formation_initial_quantity = 5
      @scheduler = Scheduler.new(@slot)
    end

    describe "without resetable slot" do
      before do
        expect(@slot).to receive(:resetable?).and_return(false)
      end

      it "should return false" do
        expect(@scheduler.reset!).to be false
      end
    end

    describe "with resetable slot" do
      before do
        expect(@slot).to receive(:resetable?).and_return(true)

        @scaler = double(Scaler)
        allow(@scheduler).to receive(:scaler).and_return(@scaler)
      end

      it "should set the initial values" do
        expect(@scaler).to receive(:scale_to).once.with(
          @slot.formation_initial_size,
          @slot.formation_initial_quantity
        )

        @scheduler.reset!
      end
    end
  end
end
