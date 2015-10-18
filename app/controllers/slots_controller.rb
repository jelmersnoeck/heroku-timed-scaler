class SlotsController < ApplicationController
  def index
    @slots = Slot.scheduled
  end

  def new
    @slot = Slot.new
  end

  def create
    @slot = Slot.new(slot_params)

    if @slot.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    slot = Slot.find(params[:id])
    slot.cancel! if slot.deletable?

    redirect_to root_path
  end

  private
  def slot_params
    params.require(:slot).permit(:from, :to, :formation_size, :formation_type,
                                :formation_quantity)
  end
end
