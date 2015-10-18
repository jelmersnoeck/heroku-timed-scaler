require 'rails_helper'

RSpec.describe Slot, type: :model do
  it { should validate_presence_of(:from) }
  it { should validate_presence_of(:to) }
  it { should validate_presence_of(:formation_size) }
  it { should validate_presence_of(:formation_type) }
  it { should validate_presence_of(:formation_quantity) }

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
