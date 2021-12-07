# ----------------------------------------- класс грузовой поезд ----------------------------

class CargoTrain < Train
  
  def initialize(number, num_of_cars)

    super(number, type="грузовой", num_of_cars)
  end 

  def type
    "грузовой"
  end  
end
