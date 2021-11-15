=begin
**********************************************************************************************
Класс Route (Маршрут):
   Имеет название, начальную и конечную станцию, а также список промежуточных станций. 
   Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
    Может добавлять промежуточную станцию в список
    Может удалять промежуточную станцию из списка
    Может выводить список всех станций по-порядку от начальной до конечной
***********************************************************************************************
=end

class Route

  #require 'instance_counter'
  include InstanceCounter

  attr_reader :name
  attr_accessor :station

  @@list_routes = []

# ------------------------------------- Создать маршрут ---------------------------------------------

  def initialize(cod_route,begin_station, end_station)                      #------ Создать маршрут
    @name = cod_route.to_s + ":" + begin_station + "-" + end_station  #------ Название маршрута
    @station = [begin_station, end_station]        
    register_instance           
    @@list_routes.push(self)
  end
  
#------------------------------------ список Obj станций ------------------------------------------------
  def self.all
    @@list_routes
  end 

  # --------------------------------- добавить станцию в маршрут --------------------------------------
  def add_station(name_st, prev_st)		                       
    if @station.include?(prev_st) == nil
       puts "Нет такой станции #{prev_st} в списке!"
    else  
      index = @station.index(prev_st) +1
      @station.insert(index, name_st) 
    end
  end

  # -------------------------------- удалить станцию из списка ---------------------------------------------

  def del_station(name_st)			                             
    if @station.include?(name_st) == nil
       puts "Нет такой станции в списке!"
    else   
       index = @station.index(name_st).to_i
       if (index == 0) || (index == @station.size-1)
         puts "#{name_st} - это начало маршрута!" if (index == 0) 
         puts "#{name_st} - это конец маршрута!" if (index == @station.size-1)
       else
         @station.delete(name_st)
       end
    end
  end
  
  # -------------------------------- очистить маршрут ---------------------------------------------

  def clear_stations				                                  
    beg_st = @station.first
    end_st = @stationх.last
    @station.clear
    @station << beg_st << end_st
  end

  # ------------------------------- показать станции в маршруте -----------------------------------

  def show_stations				                                  
    puts "***** Схема маршрута: ************"
    print "<- "
    @station.each { |name_st| print "#{name_st} - " }
    puts ">"
  end

  # ------------------------------- информация о маршруте ------------------------------------ 

  def info
    puts "Название маршрута   - #{@name}"               # название маршрута
    puts "Количество станций  - #{@station.size}"             # число станций в маршруте  
    puts "Начальная станция   - #{@station[0]}"               # начальная станция
    puts "Конечная станция    - #{@station[-1]}"              # конечная станция
    print "Состав маршрута     "
    @station.each { |name_st| print "- #{name_st}" }          # список станций на маршруте
    puts ">"
  end

end
