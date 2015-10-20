require 'rails_helper'

RSpec.describe Slot, type: :model do
  it { should validate_presence_of(:from) }
  it { should validate_presence_of(:to) }
  it { should validate_presence_of(:formation_size) }
  it { should validate_presence_of(:formation_type) }
  it { should validate_presence_of(:formation_quantity) }

  describe "formation size-quantity validation" do
    it "'free' size can only have quantity 1" do
      slot = FactoryGirl.build(
        :slot,
        formation_size: 'free',
        formation_quantity: 5
      )

      expect(slot.valid?).to be false

      slot.formation_quantity = 1
      expect(slot.valid?).to be true
    end

    it "'hobby' size can only have quantity 1" do
      slot = FactoryGirl.build(
        :slot,
        formation_size: 'hobby',
        formation_quantity: 5
      )

      expect(slot.valid?).to be false

      slot.formation_quantity = 1
      expect(slot.valid?).to be true
    end
  end

  describe "time type validation" do
    before do
      FactoryGirl.create(
        :slot,
        from: 2.days.ago,
        to: 2.days.from_now,
        formation_type: 'web'
      )
    end

    it "should not create a new slot that starts within an existing slot" do
      slot = FactoryGirl.build(
        :slot,
        from: 1.days.ago,
        to: 5.days.from_now,
        formation_type: 'web'
      )

      expect(slot.valid?).to be false
    end

    it "should not create a new slot that ends within an existing slot" do
      slot = FactoryGirl.build(
        :slot,
        from: 5.days.ago,
        to: 1.days.from_now,
        formation_type: 'web'
      )

      expect(slot.valid?).to be false
    end

    it "should not create a new slot that begins and ends within an existing slot" do
      slot = FactoryGirl.build(
        :slot,
        from: 1.days.ago,
        to: 1.days.from_now,
        formation_type: 'web'
      )

      expect(slot.valid?).to be false
    end

    it "should create a new slot from a different formation type" do
      slot = FactoryGirl.build(
        :slot,
        from: 1.days.ago,
        to: 1.days.from_now,
        formation_type: 'worker'
      )

      expect(slot.valid?).to be true
    end
  end

  describe "#set_initial_values" do
    before do
      @slot = FactoryGirl.create(:slot)
    end

    it "should update the quantity and size" do
      @slot.set_initial_values("standard-1x", 5)

      expect(@slot.reload.formation_initial_size).to eq("standard-1x")
      expect(@slot.reload.formation_initial_quantity).to eq(5)
    end
  end

  describe "#scaleable?" do
    it "should not be scaleable if we're before the from time" do
      @slot = FactoryGirl.create(:slot, :future)

      expect(@slot.scaleable?).to be false
    end

    it "should not be scaleable if we're after the to time" do
      @slot = FactoryGirl.create(:slot, :passed)

      expect(@slot.scaleable?).to be false
    end

    it "should not be scaleable if there's an initial size" do
      @slot = FactoryGirl.create(
        :slot,
        :active,
        formation_initial_size: "hobby"
      )

      expect(@slot.scaleable?).to be false
    end

    it "should not be scaleable if there's an initial quantity" do
      @slot = FactoryGirl.create(
        :slot,
        :active,
        formation_initial_quantity: 3
      )

      expect(@slot.scaleable?).to be false
    end

    it "should be scaleable if it's within the period and no initial values have been set" do
      @slot = FactoryGirl.create(:slot, :active)

      expect(@slot.scaleable?).to be true
    end
  end

  describe "#resetable?" do
    it "should not be resetable if it's before the to time" do
      @slot = FactoryGirl.create(:slot, to: 1.minute.ago)

      expect(@slot.scaleable?).to be false
    end

    it "should not be resetable if there is no initial size" do
      @slot = FactoryGirl.create(
        :slot,
        :passed,
        :scaled,
        formation_initial_size: nil
      )

      expect(@slot.resetable?).to be false
    end

    it "should not be resetable if there is not initial quantity" do
      @slot = FactoryGirl.create(
        :slot,
        :passed,
        :scaled,
        formation_initial_quantity: nil
      )

      expect(@slot.resetable?).to be false
    end

    it "should be resetable if it's before the end time and has initial values" do
      @slot = FactoryGirl.create(:slot, :scaled, :passed)

      expect(@slot.resetable?).to be true
    end
  end

  describe "#schedule!" do
    before do
      @slot = FactoryGirl.create(:slot)
    end

    it "should delay a scaled job" do
      scheduler = double(Scheduler)
      expect(scheduler).to receive(:scale).once.with(@slot.id)
      expect(Scheduler).to receive(:schedule).once.with(@slot.from).
        and_return(scheduler)

      @slot.schedule!
    end
  end

  describe "#deletable?" do
    it "should not be deletable if the slot is active but not cancelled" do
      slot = FactoryGirl.build_stubbed(:slot)
      allow(slot).to receive(:active?).and_return(true)
      allow(slot).to receive(:cancelled?).and_return(false)

      expect(slot.deletable?).to be false
    end

    it "should not be deletable if the slot is not active but cancelled" do
      slot = FactoryGirl.build_stubbed(:slot)
      allow(slot).to receive(:active?).and_return(false)
      allow(slot).to receive(:cancelled?).and_return(true)

      expect(slot.deletable?).to be false
    end

    it "should not be deletable if the slot is not active and not cancelled" do
      slot = FactoryGirl.build_stubbed(:slot)
      allow(slot).to receive(:active?).and_return(false)
      allow(slot).to receive(:cancelled?).and_return(false)

      expect(slot.deletable?).to be true
    end
  end

  describe "#active?" do
    it "should not be active if from is after now" do
      @slot = FactoryGirl.create(:slot, :future)

      expect(@slot.active?).to be false
    end

    it "should not be active if to is before now" do
      @slot = FactoryGirl.create(:slot, :passed)

      expect(@slot.active?).to be false
    end

    it "should be active if from is before now and to is after now" do
      @slot = FactoryGirl.create(:slot, :active)

      expect(@slot.active?).to be true
    end
  end

  describe "#cancel!" do
    before do
      @slot = FactoryGirl.create(:slot)
    end

    it "should mark the slot as cancelled" do
      expect(@slot.cancelled).to be(false)
      @slot.cancel!
      expect(@slot.cancelled).to be(true)
    end
  end

  describe "scopes" do
    describe ".scheduled" do
      before do
        @slot1 = FactoryGirl.create(:slot, from: 5.days.ago, to: 3.day.ago)
        @slot2 = FactoryGirl.create(:slot, from: 2.days.ago, to: 1.day.from_now)
      end

      let(:records) { Slot.scheduled }

      it { expect(records).to include(@slot2) }
      it { expect(records).not_to include(@slot1) }
    end
  end
end
