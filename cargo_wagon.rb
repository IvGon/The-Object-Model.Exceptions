# -------------------------- Класс CargoWagon (грузовой вагон )---------------------------------
class CargoWagon  < Wagon

  attr_reader :reg_number, :type_wagon
  
  def initialize(reg_number,type_wagon="грузовой")
    super(reg_number,"грузовой")
  end

   def type_wagon
    "грузовой"
  end

end
