# encoding: utf-8
module VatsimTools
  class Station
    require "gcmapper"

    attributes = %w{callsign name role frequency altitude groundspeed aircraft
      origin destination rating facility remarks route atis logon latitude longitude
      planned_altitude transponder heading qnh_in qnh_mb flight_type cid gcmap
      latitude_humanized longitude_humanized online_since gcmap_width gcmap_height
      atis_message}
    attributes.each {|attribute| attr_accessor attribute.to_sym }

    def initialize(station, args = nil)

      @callsign, @cid,  @name, @role, @frequency, @latitude, @longitude,  @altitude, @groundspeed, @aircraft, @origin,
        @planned_altitude, @destination, @transponder, @facility, @flight_type, @remarks, @route, @logon, @heading,
        @qnh_in, @qnh_mb = station[0], station[1], station[2], station[3], station[4], station[5], station[6], station[7],
        station[8], station[9], station[11], station[12], station[13], station[17], station[18], station[21], station[29],
        station[30], station[37], station[38], station[39], station[40]

      @atis = atis_cleaner(station[35]) if station[35]
      @rating = humanized_rating(station[16])
      @latitude_humanized = latitude_parser(station[5].to_f)
      @longitude_humanized = longitude_parser(station[6].to_f)
      @online_since = utc_logon_time if @logon
      @gcmap_width = args[:gcmap_width].to_i if args && args[:gcmap_width]
      @gcmap_height = args[:gcmap_height].to_i if args && args[:gcmap_height]
      @gcmap = gcmap_generator
      @atis_message = construct_atis_message(station[35]) if station[35]
    end

  private

    def gcmap_generator
      return "No map for ATC stations" if @role != "PILOT"
      construct_gcmap_url.gcmap(:width => @gcmap_width, :height => @gcmap_height)
    end

    def construct_gcmap_url
      if @origin && @latitude_humanized && @longitude_humanized && @destination
        route = @origin + "-" + @latitude_humanized + "+" + @longitude_humanized + "-" + @destination
        route += "%2C+\"" + @callsign + "%5Cn" + @altitude + "+ft%5Cn" + @groundspeed + "+kts"
        route += "\"%2B%40" + @latitude_humanized + "+" + @longitude_humanized
      else
        route = "Position undetermined"
      end
      route
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

    def humanized_rating(rating_number)
      case rating_number
        when "0" then "Suspended"
        when "1" then "OBS"
        when "2" then "S1"
        when "3" then "S2"
        when "4" then "S3"
        when "5" then "C1"
        when "7" then "C3"
        when "8" then "INS"
        when "10" then "INS+"
        when "11" then "Supervisor"
        when "12" then "Administrator"
        else
          "UNK"
      end
    end

    def construct_atis_message(raw_atis)
      message = raw_atis.gsub(/[\^]/, '<br />')
      message.index('>') ? message = message[message.index('>')+1...message.length] : message = "No published remark"
    end

  end
end
