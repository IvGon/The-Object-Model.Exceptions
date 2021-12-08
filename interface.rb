class Interface
#def initialize(spr_station,spr_route,spr_train,park_wagon)

#end

  include Validation
  #include Validate
  NUMBER_FORMAT = /^\d{3}-?[а-яА-Я]{2}$/i

  def menu(spr_station,spr_route,spr_train,park_wagon)

   cmd = "cmd"
   until cmd == "stop" do

    case cmd
    # --------------------- Просмотр справочников стаций, маршрутов, поездов --------------------------------- 

    when "wg ls"              # справочник вагонов
      print ("№".center 7) + ("Тип вагона".center 14) + ("Вид".center 10) + ("Поезд".center 15) + "\n" 
   
      Wagon.all.each { |wagon| print "#{(wagon.reg_number.center 7)} #{(wagon.type_wagon.ljust 14)} "\
                                      "#{(wagon.location.center 15)} #{wagon.to_s}\n"}               
      puts  

    when "tr ls"              # ---------------------------------------- справочник поездов

      print ("№".center 7) + ("ObjTrain".center 27)  + ("Маршрут".center 28) + ("Тип поезда".center 16) + \
          ("Станция".center 15) + ("Вагонов".center 7) + "\n" 

      Train.all.each { |train| print "#{ (train.number.center 7)} "\
                                    "#{ (train.to_s.ljust 27) } "\
                                    "#{ (train.route.to_s.ljust 27) } "\
                                    "#{ (train.type.center 14) } "\
                                    "#{ (train.train_curent_station.to_s.ljust 15) } "\
                                    "#{ (train.number_cars.to_s.center 7) }\n"}

    when "st ls"              # ---------------------------------------- справочник станций
      print " Obj_Станция       Название станции\n"
      Station.all.each { |station| print "#{station} #{station.name}  \n" }

    when "rt ls"              # ---------------------------------------- справочник vмаршрутов
      spr_route.each do |route|                                         
        print (route.name.ljust  25) + (route.to_s.ljust 27) + "\n"
        route.station.each_with_index do |st,i|  
          20.times { print " " } if i%4 == 0
          print "#{(st.ljust 15)}  "
          print "\n" if (i+1)%4 == 0
        end
        print "\n" 
      end
      puts 

    # -------------------------------------------------------------------------------------------------------------
    when "station+"      #--------------- создать новую станцию и внести в справочник станций
      begin
        print "Название станци: "
        name_st = gets.chomp.to_s
        st_obj = spr_station.find { |item| item.name == name_st} 
        st_obj = Station.new_if_valid(name_st) if st_obj.nil?
        raise "Неудачная попытка создания станции!" unless st_obj.valid?

      rescue StandardError => e
        puts e.message
        print "Продолжить ввод (0 - нет, 1 - да): "
        retry if gets.chomp.to_i == 1
      else
        puts "Станция #{name_st} успешно создана!"
        puts st_obj
      end

    when "station-"   # ---------------- создать новую станцию и внести в справочник станций
      begin
        print "Название станци: "
        name_st = gets.chomp.to_s
        st_obj = spr_station.find { |item| item.name == name_st} 
        puts st_obj
        raise "Нет такой станции   #{name_st}!" if st_obj.nil?
        spr_station.delete(st_obj)
      rescue StandardError => e
        puts e.message
        print "Продолжить ввод (0 - нет, 1 - да): "
        retry if gets.chomp.to_i == 1
      else
        puts "Станция #{name_st} успешно удалена!"
      end

    when "route+"  # -------------------------------  создать новый маршрут -------------
      begin
        print "Код маршрута: "
        cod = gets.chomp.to_s

        print "Начальная станци маршрута: "
        beg_st = gets.chomp.to_s
        st_obj = Station.new_if_valid(beg_st) if spr_station.find { |item| item.name == beg_st}.nil?
        raise "Не удалось определить начальную станцию маршрута!" if st_obj.nil?

        print "Конечная станци маршрута: "
        end_st = gets.chomp.to_s
        st_obj = Station.new_if_valid(end_st) if spr_station.find { |item| item.name == end_st}.nil?
        raise "Не удалось определить конечную станцию маршрута!" if st_obj.nil?
        route = Route.new(cod,beg_st, end_st)
        raise "Неудачная попытка создания маршрута!" unless route.valid?

      rescue StandardError => e
        puts e.message
        print "Продолжить ввод (0 - нет, 1 - да): "
        retry if gets.chomp.to_i == 1
      else
        puts "Маршрут № #{cod} от #{beg_st} до #{end_st} успешно создан!"
        puts route
      end

    # ----------------------------- добавить станцию в маршрут ------------------------
    
    when "st add"
      work_st = route.station                   # <-------указатель на массив станций
    
      print "Добавить станцию в маршруте: "     # <-------добавляемая станция
      new_st = gets.chomp.to_s
      
      if work_st.include?(new_st)
        puts "Такая станция есть в списке!"
      else
        print "Вставить после станции: "        # <-------предыдущая станция
        prev_st = gets.chomp.to_s
        if work_st.include?(prev_st)
        
          if work_st.index(prev_st) == work_st.size-1
            puts "Эта станция за конечной станцией!" 
          else
            route.add_station(new_st,prev_st)   # <------- добавить станцию
          end     
        else 
          puts "Нет такой станции в списке!" 
        end         
      end    

    # ----------------------------- удалить станцию из маршрута ------------------------
    when "st del"
      print "Удалить станцию: "
      new_st = gets.chomp.to_s
      puts "Ошибка при удалении станции #{new_st}" if route.del_station(new_st) == nil
    
    # ----------------------------- очистить маршрут -----------------------------------
    when "st clear"
      puts "Ошибка при удалении станций" if route.clear_station == nil
    
    # ----------------------------- показать станции из маршрута ------------------------
    when "rt show"
      route.show_stations

    # -----------------------------

    when "train" # ---------------------------------- создать новый состав ---------------
      begin
        print "Номер поезда (ЦЦЦ-Пс): "
        num_train = gets.chomp.to_s
        raise ArgumentError, "Номер не может быть пустым!" if num_train == ""
        #raise ArgumentError, "Неверный формат номера поезда: #{num_train} !" if num_train !~ NUMBER_FORMAT 

        print "Тип поезда (1 - грузовой, 2 - пассажирский): "
        type = gets.chomp.to_i
        raise ArgumentError, "Тип поезда должен быть - 1 или 2!" unless [1,2].include? type

        print "Количество вагонов: "
        num_cars = gets.chomp.to_i
        raise ArgumentError, "Маловато вагонов будет!" if num_cars < 1

        train = CargoTrain.new(num_train,num_cars) if type == 1
        train = PassengerTrain.new(num_train,num_cars) if type == 2
        #train = Train.new(num_train,"пасажирский",num_cars)
        raise RuntimeError, "Неудачная попытка создания объекта!" unless train.obj_valid?
      rescue  => e
        if e.class == RuntimeError
          puts "errors: " + train.errors.to_s
        else
          puts "#{e.class}: #{e.message}"
        end
        print "Продолжить ввод (0 - нет, 1 - да): "
        retry if gets.chomp.to_i == 1
      else
        if train.obj_valid?
          puts "Поезд номер #{num_train} успешно создан!"
          puts train
        else
           puts "Неудачная попытка создания объекта!" 
           puts "errors: " + train.errors.to_s
        end
      end

    when "tr find" # -------------------------выбрать и установить активным поезд №  --------
      print "Номер поезда: "
      num_train = gets.chomp.to_s
     
      train = spr_train.find{ |item| item.number == num_train }
      puts "Нет такого поезда!" if train.nil?
      train.info

    when "car" #----------------------------------- создать новый вагон ----------------------

      print "Номер вагона: "
      num_wagon = gets.chomp.to_s
      print "Тип вагона: (0 - грузовой, 1 - пассажирский): "
      type = gets.chomp.to_i

      wagon = PassengerWagon.new(num_wagon) if type == 1
      wagon = CargoWagon.new(num_wagon) if type == 0
    
    when "car+"         # ----------------------------- car+ - прицепить вагон к составу ------
      begin 
        raise "Не определен поезд!" if train.nil?
        train.speed=0     
        print "Номер вагона: "
        num_wagon = gets.chomp.to_s

        next_car = park_wagon.find { |item| item.reg_number == num_wagon} 
        raise "Нет такого вагона #{num_wagon}!" if next_car.nil?
      
      rescue StandardError => e
          puts e.message
          print "Продолжить ввод (0 - нет, 1 - да): "
          retry if gets.chomp.to_i == 1
        else
          if train.add_car(next_car)                       
            next_car.attach_wagon_to_train(train)
            puts "Вагон номер #{num_wagon} успешно прицеплен к поезду № #{num_train}!"
          end
      end

    when "car-"   # ---------------------------------- - отцепить вагон от состава -------------
      begin 
        raise "Не определен поезд!" if train.nil?
        train.speed=0     
        print "Отцепить от поезда вагон № : "
        num_wagon = gets.chomp.to_s

        next_car = park_wagon.find { |item| item.reg_number == num_wagon} 
        raise "Нет такого вагона #{num_wagon}!" if next_car.nil?
      
      rescue StandardError => e
          puts e.message
          print "Продолжить ввод (0 - нет, 1 - да): "
          retry if gets.chomp.to_i == 1
        else
          next_car.unhook_wagon_from_train(train)
          train.del_car(next_car) 
          puts "Вагон номер #{num_wagon} успешно отцеплен от поезда № #{num_train}!"
      end
    
    when "car num"  # --------------------------------- количество вагонов в поезде -------------
      train.number_cars unless train.nil?
      
    # -------------------------- Движение поезда по маршруту ---------------------    
    when "set route"   # -------------------------- route - назначить поезду маршрут --------
      raise "Не определен поезд!" if train.nil?
      train.assign_train_route(route) 

    when "tr stat"    # ----------------------------- текущая станция поезда на маршруте ----------------
      print "Номер поезда: "
      num_train = gets.chomp.to_s

      train_obj = spr_train.find { |item| item.number == num_train} 
      if train_obj.nil?
          puts "Нет такого поезда #{num_train}"
      else  
        train_obj.train_curent_station
      end
  
    when "tr next"   # ----------------------------- поезд вперед на 1 станцию по маршруту ------
      train.train_forward
      
    when "tr prev"   # ----------------------------- поезд назад на 1 станцию по маршруту --------
      train_forward_back
 
    # -------------------------- Движение поездов по станции ---------------------   
    when "st in"  # <------------------------------- принять поезд на станцию -------------------

      print "Принять на станцию поезд № : "
      num_train = gets.chomp.to_s
      # <------------------------- найти поезд по номерув в справочнике поездов
      train_obj = spr_train.find { |item| item.number == num_train} 
      next_station = train_obj.train_next_station
      if train_obj.nil?
          puts "Нет такого поезда #{num_train}"
      else  
        if next_station.nil? == false
          train_obj.speed = 0

          st_obj = spr_station.find { |item| item.name == next_station} 
           # ----- добавить поезд на станцию    
          st_obj.train_arrival(train_obj) 
        end
      end

    when "st out"   # <------------------------------ отправить поезд со станции по маршруту -------------------

      # <------------------------- найти поезд по номерув в справочнике поездов
      print "Отправить со станции поезд № : "
      num_train = gets.chomp.to_s
      train_obj = spr_train.detect { |item| item.number == num_train}  

      if train_obj.nil?
        puts "Нет такого поезда #{num_train}"
      else  
        cur_station = train_obj.curent_station

        if cur_station.nil? == false

          train_obj.speed = 80  
          # <----------------------- станция отправления = текущая станция остановки поезда ----------------------
          st_obj = spr_station.find { |item| item.name == cur_station} 
          st_obj.train_departure(train_obj) if st_obj.nil? == false
        end                                     
      end

    when "st show"     # <------------------------------ показать поезда на станции -----------------------------
      
      print "Показать поезда на станции : "
      name_station = gets.chomp.to_s
      st_obj = spr_station.find { |item| item.name == name_station} 
      
      print "Тип вагона: (0 - грузовой, 1 - пассажирский): "
      type = gets.chomp.to_i

      type_train = "грузовой" if type == 0 
      type_train = "пассажирский" if type == 1

      if st_obj.nil?
        puts "На станции  #{st_obj.name}  "
      else
        puts st_obj.list_of_trains(type_train).to_s + " " + type_train + " поезд"
      end

    # -------------------------- Скорость движения поезда -------------------------    

    when "tr up"  # <------------------------------- набирать скорость поезда ------
      print "Набрать скорость поезда: "
      speed = gets.chomp.to_f
      train.speed = speed
    
    when "tr down"  # <----------------------------- снизить скорость поезда -------
      print "Снизить скорость поезда до: "
      speed = gets.chomp.to_f
      train.speed = speed
    
    when "speed"   # <--------------------------- speed - определить скорость поезда
      puts train.speed
  
    # -------------------------- Информация о поезде --------------------------------
    when "info"
      train.info
     
    # -------------------------- Меню команд ---------------------------------------
    when "cmd"
      puts
      puts "Для продолжения работы введите команду:\n\n"
      puts "-------------- Справочники --------------------------"
      puts "wg ls     - справочник вагонов"
      puts "tr ls     - справочник поездов"
      puts "st ls     - справочник станций"
      puts "rt ls     - справочник маршрутов"
      puts "------- Формирование маршрута поезда ------------------"
      puts "station+  - создать станцию"
      puts "station-  - удалить станцию"
      puts "route+    - создать маршрут"
      puts "st add    - вставить станцию в маршрут"
      puts "st del    - удалить станцию из маршрута"
      puts "rt show   - показать станции маршрута"
      puts "set route - назначить поезду маршрут"
      puts "------ Формирование состава --------------------------"
      puts "tr find   - выбрать и установить активным поезд № "
      puts "train     - создать новый состав"
      puts "car       - создать вагон"
      puts "car+      - прицепить вагон к составу"
      puts "car-      - отцепить вагон от состава"
      puts "set route - назначить поезду маршрут"
      puts "info      - показать информацию о поезде"
      puts "------- Движение поездов по станции ------------------"
      puts "st in     - принять поезд на станцию"
      puts "st out    - отправить поезд со станции по маршруту"
      puts "st show   - показать список поездов на станции"
      puts "------- Движение поезда по  маршруту ------------------"
      puts "tr next   - поезд вперед на 1 станцию по маршруту"
      puts "tr prev   - поезд назад на 1 станцию по маршруту"
      puts "tr up     - набрать скорость"
      puts "tr down   - тормозить (сбрасывать скорость до нуля)"
      puts "speed     - возвратить текущую скорость" 
      puts "-----------------------------------------------------"
      puts "cmd       - вывод меню команд на экран" 
      puts "stop      - завершить работу"
      puts "---------------------------------------\n\n"
  
    when "stop"         #stop - завершение работы
      break
  
    else
      puts "Неудачная команда?"
    end

    print "cmd> "
    cmd = gets.chomp.to_s     # Выбор команды
  
   end           # end of until CMD
  end
end