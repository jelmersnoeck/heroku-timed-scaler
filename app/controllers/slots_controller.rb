class SlotsController < ApplicationController
  def index
    @slots = Slot.all
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
    Slot.find(params[:id]).cancel!

    redirect_to root_path
  end

  private
  def slot_params
    params.require(:slot).permit(:from, :to, :formation_size, :formation_type)
  end
end
