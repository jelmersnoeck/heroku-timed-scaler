require "rails_helper"

RSpec.describe Importer do
  describe "#valid?" do
    describe "with faulty data" do
      before do
        data = [
          {
            from: 1.day.ago,
            to: 1.day.from_now,
            formation_type: 'web',
            formation_size: 'non-existing',
            formation_quantity: '2',
          }
        ]
        @importer = Importer.new(data)
      end

      it { expect(@importer.valid?).to be false }
    end

    describe "with correct data" do
      before do
        data = [
          {
            from: 1.day.ago,
            to: 1.day.from_now,
            formation_type: 'web',
            formation_size: 'standard-1x',
            formation_quantity: '2',
          }
        ]
        @importer = Importer.new(data)
      end

      it { expect(@importer.valid?).to be true }
    end
  end

  describe "#save" do
    before do
      data = [
        {
          from: 1.day.ago,
          to: 1.day.from_now,
          formation_type: 'web',
          formation_size: 'standard-1x',
          formation_quantity: '2',
        },
        {
          from: 3.days.ago,
          to: 2.days.ago,
          formation_type: 'web',
          formation_size: 'standard-1x',
          formation_quantity: '2',
        }
      ]
      @importer = Importer.new(data)
    end

    it "should not create any records if the records aren't valid" do
      expect(@importer).to receive(:valid?).and_return(false)

      expect {
        @importer.save
      }.to change { Slot.count }.by 0
    end

    it "should create new slots if the records are valid" do
      expect {
        @importer.save
      }.to change { Slot.count }.by 2
    end
  end
end
