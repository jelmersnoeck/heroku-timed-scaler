require 'rails_helper'

RSpec.describe SlotsController, type: :controller do
  describe "GET#index" do
    it "should get all scheduled items" do
      scheduled = double(:scheduled)
      expect(Slot).to receive(:scheduled).and_return(scheduled)

      get :index

      expect(response.status).to eq(200)
      expect(response).to render_template(:index)
      expect(assigns(:slots)).to eq(scheduled)
    end
  end

  describe "GET#new" do
    it "should render the new template" do
      get :new

      expect(response.status).to eq(200)
      expect(response).to render_template(:new)
    end
  end

  describe "POST#create" do
    it "should create a new item" do
      attributes = FactoryGirl.attributes_for(:slot, :future)
      # attributes_for returns an int, need the value
      attributes[:formation_size] = Slot::FORMATION_SIZES.first

      expect {
        post :create, slot: attributes
      }.to change { Slot.count }.by 1

      expect(response).to redirect_to(root_path)
    end

    it "should render the new page if invalid" do
      attributes = FactoryGirl.attributes_for(:slot, :future)
      attributes[:formation_size] = nil

      post :create, slot: attributes

      expect(response).to render_template(:new)
    end
  end

  describe "DELETE#destroy" do
    before do
      @slot = FactoryGirl.create(:slot, :future)
      expect(Slot).to receive(:find).at_least(:once).and_return(@slot)
    end

    it "should check that the slot is deletable" do
      expect(@slot).to receive(:deletable?).and_return(true)

      expect {
        delete :destroy, id: @slot.id
      }.to change { @slot.reload.cancelled? }.from(false).to(true)

      expect(response).to redirect_to(root_path)
    end

    it "should check that the slot is deletable" do
      expect(@slot).to receive(:deletable?).and_return(false)

      expect {
        delete :destroy, id: @slot.id
      }.not_to change { @slot.reload.cancelled? }

      expect(response).to redirect_to(root_path)
    end
  end
end
