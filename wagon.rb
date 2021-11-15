=begin
*************************************************************************************************
Класс Wagon (Вагон):
    Имеет номер - reg_number, тип  type_wagon (грузовой, пассажирский). 
    эти данные указываются при создании экземпляра класса.
    
    Вагоны теперь делятся на грузовые и пассажирские (отдельные классы). 
    К пассажирскому поезду можно прицепить только пассажирские, к грузовому - грузовые. 
    При добавлении вагона к поезду, объект вагона должен передаваться 
    как аргумент метода и сохраняться во внутреннем массиве поезда, 
    в отличие от предыдущего задания, где мы считали только кол-во вагонов. 
    Местонахождение поезда location: вагон может находиться в составе поезда либо на станции.

*************************************************************************************************
=end

class Wagon
  #require 'manufacturer'
  #require 'instance_counter'
  include Manufacturer
  include InstanceCounter

  attr_accessor :location                 #----- местоположение вагона: новый, на станции, в поезде
  attr_reader :reg_number, :type_wagon    #----- номер и тип вагона

  @@list_wagons = []

#------------------------------------ список Obj вагонов ----------------------------------------
  def self.all
    @@list_wagons 
  end

#-------------------------------------------------------------------------------------------------
  def initialize(reg_number,type_wagon)
    @reg_number=reg_number
    @type_wagon=type_wagon
    @location = "NEW"
    @@list_wagons.push(self)
    register_instance
  end

  # ------------------ Прицепить к поезду ---------------------------------------------------------
  def attach_wagon_to_train(train)
    @location = train.number if train.wagons.include?(self)
  end

  # ------------------ Отцепить вагон от поезда ----------------------------------------------------
  def unhook_wagon_from_train(train)

    @location = train.curent_station if train.wagons.include?(self)
  end

  # ------------------ # Назначить тип вагона ----------------------------------------------------
  def assign_type_wagon(type_wagon)                           
    assign_type_wagon!(type_wagon) if type_wagon.nil?
  end

  private

    attr_writer :type_wagon
    attr_writer :manufacturer

    def assign_type_wagon!(type_wagon)

      h_wagon_type = { :pass => "пассажирский", :cargo => "грузовой"} 
      
      initial_type = h_wagon_type[type_wagon]
      self.type_wagon = initial_type
    end

end