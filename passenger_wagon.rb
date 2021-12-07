# -------------------------- Класс PassengerWagon (пассажирский вагон )---------------------------
class PassengerWagon < Wagon
  
  attr_reader :reg_number, :type_wagon

  def initialize(reg_number,type_wagon="пассажирский")
    super(reg_number,"пассажирский")
  end

  def type_wagon
    "пассажирский"
  end

end