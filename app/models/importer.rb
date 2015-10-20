class Importer
  attr_reader :errors, :slots

  def initialize(data)
    @data = data
    @run = false
    @errors = false
    @slots = []
  end

  def valid?
    build unless @run
    !errors
  end

  def save
    return unless valid?

    slots.each do |slot|
      slot.save
    end
  end

  private
  def build
    @data.each do |slot_data|
      slot = Slot.new(slot_hash(slot_data))
      @slots << slot
      @errors = true if !slot.valid?
    end
    @run = true
  end

  def slot_hash(data)
    {
      from: data[:from],
      to: data[:to],
      formation_type: data[:formation_type],
      formation_size: data[:formation_size],
      formation_quantity: data[:formation_quantity],
    }
  end
end
