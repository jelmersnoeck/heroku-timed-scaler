require 'csv'

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

  def upload_csv
  end

  def import
    importer = Importer.new(CSV.table(import_params[:csv].path))

    if importer.valid?
      importer.save
      redirect_to root_path
    else
      @slots, @errors = importer.slots, true
      render :upload_csv
    end
  end

  private
  def slot_params
    params.require(:slot).permit(:from, :to, :formation_size, :formation_type,
                                :formation_quantity)
  end

  def import_params
    params.require(:upload).permit(:csv)
  end
end
