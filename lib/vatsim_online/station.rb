module VatsimOnline
  class Station
    attributes = %w{callsign name role frequency altitude groundspeed aircraft
                 departure destination rating facility remarks route atis logon}
    attributes.each {|attribute| attr_accessor attribute.to_sym }


    def initialize(station)
      @callsign = station[0]
      @name = station[2]
      @role = station[3]
      @frequency = station[4]
      @altitude = station[7]
      @groundspeed = station[8]
      @aircraft = station[9]
      @departure = station[11]
      @destination = station[13]
      @rating = station[16]
      @facility = station[18]
      @remarks = station[29]
      @route = station[30]
      @atis = station[35]
      @logon = station[37]
    end

  end
end
