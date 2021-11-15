# ----------------------------------------- класс пассажирский поезд -----------------------

class  PassengerTrain < Train 
  
  def initialize(number, num_of_cars)
  
      super(number, type="пассажирский", num_of_cars)
  end

  def type
    "пассажирский"
  end
end

