# encoding: utf-8
module VatsimTools
  class Station
    require "gcmapper"

    attributes = %w{callsign name role frequency altitude groundspeed aircraft
      origin destination rating facility remarks route atis logon latitude longitude
      planned_altitude transponder heading qnh_in qnh_mb flight_type cid gcmap
      latitude_humanized longitude_humanized online_since}
    attributes.each {|attribute| attr_accessor attribute.to_sym }


    def initialize(station)
      @callsign = station[0]
      @cid = station[1]
      @name = station[2]
      @role = station[3]
      @frequency = station[4]
      @altitude = station[7]
      @planned_altitude = station[12]
      @groundspeed = station[8]
      @aircraft = station[9]
      @origin = station[11]
      @destination = station[13]
      @rating = station[16]
      @facility = station[18]
      @remarks = station[29]
      @route = station[30]
      @atis = atis_cleaner(station[35]) if station[35]
      @logon = station[37]
      @latitude = station[5]
      @latitude_humanized = latitude_parser(station[5].to_f)
      @longitude = station[6]
      @longitude_humanized = longitude_parser(station[6].to_f)
      @transponder = station[17]
      @heading = station[38]
      @qnh_in = station[39]
      @qnh_mb = station[40]
      @flight_type = station[21]
      @gcmap = gcmap_generator
      @online_since = utc_logon_time
    end

  private

    def gcmap_generator
      return "No map for ATC stations" if @role != "PILOT"
      route = @origin
      route += "-" + @latitude_humanized + "+" + @longitude_humanized
      route += "-" + @destination
      route += "%2C+\"" + @callsign + "%5Cn" + @altitude + "+ft%5Cn" + @groundspeed + "+kts"
      route += "\"%2B%40" + @latitude_humanized + "+" + @longitude_humanized
      route.gcmap
    end

    def latitude_parser(lat)
      lat > 0 ? hemisphere = "N" : hemisphere = "S"
      hemisphere + lat.abs.to_s
    end

    def longitude_parser(lon)
      lon > 0 ? hemisphere = "E" : hemisphere = "W"
      hemisphere + lon.abs.to_s
    end

    def atis_cleaner(raw_atis)
      raw_atis.gsub(/[\^]/, '. ')
    end

    def utc_logon_time
      Time.parse ("#{@logon[0...4]}-#{@logon[4...6]}-#{@logon[6...8]} #{@logon[8...10]}:#{@logon[10...12]}:#{@logon[12...14]} UTC")
    end

  end
end
