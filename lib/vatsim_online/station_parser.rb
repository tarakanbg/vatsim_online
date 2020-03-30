module VatsimTools

  class StationParser

    %w{tmpdir csv}.each { |lib| require lib }
    require_relative "data_downloader"
    require_relative "station"

    attributes = %w{role icao excluded gcmap_width gcmap_height}
    attributes.each {|attribute| attr_accessor attribute.to_sym }

    LOCAL_DATA = "#{Dir.tmpdir}/vatsim_online/vatsim_data.txt"

    def initialize(icao, args = nil)
      VatsimTools::DataDownloader.new
      args.class == Hash ? @role = determine_role(args) : @role = "all"
      if icao == "ALL"
        @icao = nil
      else
        @icao = icao.upcase.split(',').each {|s| s.strip!}
      end
      @excluded = args[:exclude].upcase if args && args[:exclude]
      @gcmap_width = args[:gcmap_width] if args && args[:gcmap_width]
      @gcmap_height = args[:gcmap_height] if args && args[:gcmap_height]
    end

    def determine_role(args)
      args[:atc] == false ? role = "pilot" : role = "all"
      args[:pilots] == false ? role = "atc" : role = role
      role = "all" if args[:pilots] == false && args[:atc] == false
      role
    end

    def stations
      stations = []
      CSV.foreach(LOCAL_DATA, :col_sep =>':') do |row|
        callsign, origin, destination, client = row[0].to_s, row[11].to_s, row[13].to_s, row[3].to_s
        unless @icao
          stations << row if (client == "ATC") unless @role == "pilot"
          stations << row if (client == "PILOT") unless @role == "atc"
        else
          for icao in @icao
            stations << row if (callsign[0...icao.length] == icao && client == "ATC") unless @role == "pilot"
            stations << row if (origin[0...icao.length] == icao || destination[0...icao.length] == icao) unless @role == "atc"
          end
        end
      end
      stations
    end

    def station_objects
      station_objects= []
      args = {}
      args[:gcmap_width] = @gcmap_width if @gcmap_width
      args[:gcmap_height] = @gcmap_height if @gcmap_height
      stations.each {|station| station_objects << VatsimTools::Station.new(station, args) }
      station_objects
    end

    def sorted_station_objects
      atc = []; pilots = []; arrivals = []; departures = []
      station_objects.each {|sobj| sobj.role == "ATC" ? atc << sobj : pilots << sobj}
      if @icao
        for icao in @icao
          for pilot in pilots
            departures << pilot if pilot.origin[0...icao.length] == icao
            arrivals << pilot if pilot.destination[0...icao.length] == icao
          end
        end
      end
      atc.delete_if {|a| @excluded && a.callsign[0...@excluded.length] == @excluded }
      {:atc => atc, :pilots => pilots, :arrivals => arrivals, :departures => departures}
    end

  end

end
