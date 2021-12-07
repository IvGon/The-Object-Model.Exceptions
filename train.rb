=begin
**********************************************************************
Класс Train (Поезд):
    Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, 
    эти данные указываются при создании экземпляра класса
    Может набирать скорость
    Может возвращать текущую скорость
    Может тормозить (сбрасывать скорость до нуля)
    Может возвращать количество вагонов
    Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает 
    или уменьшает количество вагонов). Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
    Может принимать маршрут следования (объект класса Route). 
    При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
    Может перемещаться между станциями, указанными в маршруте. 
    Перемещение возможно вперед и назад, но только на 1 станцию за раз.
    Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
****************************************************************************************************
=end

#********** Определение Класс Train (Поезд) ***********************************
class Train
  require_relative 'manufacturer'
  require_relative 'passenger_train'
  require_relative 'cargo_train'
  require_relative 'instance_counter'
  require_relative 'validate'
  include Validation
  include Validate
  include Manufacturer
  include InstanceCounter

  attr_reader :number, :type
  attr_reader :route_name, :route               # название и Obj маршрута поезда
  attr_accessor :speed, :curent_station         # возвращать текущую станцию и скорость
  
  attr_reader :condition                        # местонахождение поезда: в пути/на станции
  attr_reader :number_cars, :num_of_cars		                  # возвращать количество вагонов
  attr_reader :wagons                           # подвижной состав поезда


  @@trains = []

  NUMBER_FORMAT = /^\d{3}-?[а-яА-Я]{2}$/i
#------------------------------------ список Obj поездов ------------------------------------------------
  def self.all
    @@trains 
  end

  def initialize(number, type, num_of_cars)
      validate!(number)

      @number = number			                      # номер поезда
      @type = type				                        # тип поезда (грузовой, пассажирский)
      @wagons = []                                # состав поезда
      @num_of_cars = num_of_cars	              # количество вагонов 
      @speed = 0
      @curent_station = "Харьков"
      @@trains.push(self)
      register_instance
  end

  #def attr_validate(*args)

    #validates :number, type: String 
    #validates :number,
    #        msg: 'is not a valid format.',
    #        option: proc { |p| p.number =~ NUMBER_FORMAT }
    #validates :type, type: String
    #validates :type, 
    #        msg: 'is not valid type',
    #        option: proc { |p| ["пассажирский","грузовой"].include? p.type }
  # obj_valid?("ini")
  #end

  # --------------------------------------------- количество вагонов в поезде ----------------
  def number_cars                     			     
    @wagons.size
  end
 
 # --------------------------------------------- поиск Obj поезда по номеру ----------------
  def find(number)
    @@trains.find{|train| train.number == number}
  end


  # --------------------------------------------- назначить поезду маршрут ----------------
  def assign_train_route(assign_route) 	           
    @route = assign_route
    @curent_station = @route.station[0]
    @prev_station = nil
    @next_station = assign_route.station[1]
    @condition   = @curent_station
    Station.all.find { |item| item.name == route.station[0]}.train_arrival(self)
  end
  
  def route_name
    @route.route_name
  end

  # -------------------------------------------- Возвращать положение на маршруте --------
  def train_curent_station 	
     @curent_station
  end

  def train_next_station  
     @next_station
  end

  def train_prev_station  
     @prev_station
  end

# -------------------------------- перемещаться между станциями, указанными в маршруте ----
  
  # ----------------------------- поезд вперед на 1 станцию по маршруту -------------------
  def train_forward
      
      if @current_station != @route.stations[-1]
        speed=60
        @current_station.train_departure(self) 
        @prev_station = @curent_station
        @curent_station = @next_station
        ind = route.station.index(@curent_station).to_i + 1
        @next_station = route.station[ind]
        @current_station.train_arrival(self)
      else
        puts "Поезд уже находится в пункте назначения!" 
      end
  end

  def train_forward_back
    speed=60
    if @current_station != @route.stations[0]
      @current_station.train_departure(self) 
      
      @next_station = @curent_station
      @curent_station = @prev_station
      ind = route.station.index(@curent_station).to_i - 1
      @prev_station = route.station[ind]
      
      @current_station.add_train(self)
    else
      puts "Поезд уже находится в пункте отправления!" 
      end
  end

  # --------------------------------------- отправить поезд со станции по маршруту ----------
  def leave_the_station(station)                       		         
    @prev_station = station.name  if station.trains.include?(self)
    @curent_station = ""
    i = self.route.station.index(station.name ).to_i
    @next_station = self.route.station[i + 1]
    speed=60
  end
  
  # -------------------------------------------- принять поезд на станцию ---------------
  def arrive_at_the_station(station)			                        
    
    speed=0
    @curent_station = station.name if station.trains.include?(self)
    @next_station = ""
  end

   # -----------------------------------------  местонахождение поезда ------------------
  def condition
    if speed>0 && curent_station.empty?
      # ----------------------------------- В пути между станциями 
      @condition = "#{@prev_station} - #{@next_station}"
    else
      # ----------------------------------- На станции - #{curent_station}."
      @condition = "#{curent_station}"
    end
  end

  # ------------------------------ ИНФОРМАЦИЯ о поезде -----------------------------------

  def info
    condition
    puts "номер поезда        - #{@number}"	            # номер поезда
    puts "Obj поезда          - #{self}"                # номер поезда
    puts "тип поезда          - #{@type}"               # тип поезда
    puts "количество вагонов  - #{@num_of_cars}"        # число вагонов в поезде		
    puts "скорость            - #{@speed}"              # скорость поезда
    if @route.nil? == false
      puts "Obj маршрута        - #{@route}"              # Obj маршрута
      puts "название маршрута   - #{@route.name}"         # название маршрута
      puts "маршрут             - #{@route.station}"      # список станций по маршруту
    end
    puts "Местонахождение     - #{@condition}"          # местонахождение поезда
    puts "Текущая станция     - #{@curent_station}"     # текущая станция
    puts "Предыдущая станция  - #{@prev_station}"       # предыдущая станция
    puts "Следующая станция   - #{@next_station}"       # следующая станция 
    puts "Состав поезда       - "                       # подвижной состав поезда
    wagons.each_with_index { |wagon,i|  print "#{(i+1).to_s.rjust 5}  #{(wagon.reg_number.ljust 7)}  "\
                                              "#{(wagon.type_wagon.ljust 14)} "\
                                              "#{(wagon.location.center 15)}\n" }
  end

  # ------------------------------ прицепить вагон к поезду -----------------------------------

  def add_car(car)                          #car+  - прицепить вагон к поезду
    if speed == 0 
      if (car.type_wagon == @type)
        @num_of_cars += 1
        wagons << car
      else
        puts "тип вагона не соответствует типу поезда!"  
      end
    else
      puts "Остановите поезд!"
    end   
  end

  # ------------------------------ отцепить вагон поезда -----------------------------------

  def del_car(car)                          #car-   - отцепить вагон поезда
    if wagons.include?(car)
      @num_of_cars -= 1 if @speed == 0
      wagons.each { |item| wagons.delete(item) if item == car }
    else
      puts "нет такого вагона #{car.reg_number} в поезде!"   
    end
  end

  def validate!(number)
    raise RuntimeError, "Неверный формат номера поезда: #{number} !" if number !~ NUMBER_FORMAT    
  end
end

class TrainValidator

  include Validate

  validates :number, type: String 
  validates :number,
            msg: 'Неверный формат номера!',
            option: proc { |p| p.number =~ /^\d{3}-?[а-яА-Я]{2}$/i }
  validates :type, type: String
  validates :type, 
            msg: 'Неверный тип поезда!',
            option: proc { |p| ["пассажирский","грузовой"].include? p.type }
  validates :num_of_cars, type: Integer
  validates :num_of_cars,
            msg: 'Количество вагонов не может быть меньше 1!',
            option: proc { |p|  p.num_of_cars > 0 }
  #validates :route_name, type: String
  #validates :route, type: Route
  #validates :speed, type: Fixnum
  #validates :curent_station, type: String
  #validates :condition, type: String
  #validates :wagons, type: Wagon
end

class PassengerTrainValidator < TrainValidator
  
  validates :number, type: String 
  validates :number,
            msg: 'Неверный формат номера!',
            option: proc { |p| p.number =~ /^\d{3}-?[а-яА-Я]{2}$/i }
  validates :type, type: String
  validates :type, 
            msg: 'Неверный тип поезда!',
            option: proc { |p| ["пассажирский","грузовой"].include? p.type }
  validates :num_of_cars, type: Integer
  validates :num_of_cars,
            msg: 'Количество вагонов не может быть меньше 1!',
            option: proc { |p|  p.num_of_cars > 0 }
end

class CargoTrainValidator < TrainValidator
  def initialize
    super
  end
end

#tr=Train.new("123-Пс","пассажирский",12)
#tr.obj_valid?
