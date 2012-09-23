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
      @rating = humanized_rating(station[16])
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
      @online_since = utc_logon_time if @logon
      @gcmap_width = args[:gcmap_width].to_i if args && args[:gcmap_width]
      @gcmap_height = args[:gcmap_height].to_i if args && args[:gcmap_height]
      @gcmap = gcmap_generator
      @atis_message = construct_atis_message(station[35]) if station[35]
    end

  private

    def gcmap_generator
      return "No map for ATC stations" if @role != "PILOT"
      route = @origin
      route += "-" + @latitude_humanized + "+" + @longitude_humanized
      route += "-" + @destination
      route += "%2C+\"" + @callsign + "%5Cn" + @altitude + "+ft%5Cn" + @groundspeed + "+kts"
      route += "\"%2B%40" + @latitude_humanized + "+" + @longitude_humanized
      route.gcmap(:width => @gcmap_width, :height => @gcmap_height)
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
      when "1" then "P0/OBS"
      when "2" then "S1"
      when "3" then "S2"
      when "4" then "S3"
      when "5" then "C1"
      when "7" then "C3"
      when "8" then "I1"
      when "10" then "I3"
      else
        "UNK"
      end
    end

    def construct_atis_message(raw_atis)
      message = raw_atis.gsub(/[\^]/, '<br />')
      message = message[message.index('>')+1...message.length]
    end

  end
end
