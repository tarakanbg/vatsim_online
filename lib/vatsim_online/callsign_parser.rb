module VatsimTools

  class CallsignParser

    %w{tmpdir csv}.each { |lib| require lib }
    require_relative "data_downloader"
    require_relative "station"

    attributes = %w{role callsign gcmap_width gcmap_height}
    attributes.each {|attribute| attr_accessor attribute.to_sym }

    LOCAL_DATA = "#{Dir.tmpdir}/vatsim_data.txt"

    def initialize(callsign, args = nil)
      VatsimTools::DataDownloader.new
      # args.class == Hash ? @role = determine_role(args) : @role = "all"
      @callsign = callsign.upcase.split(',').each {|s| s.strip!}
      # @excluded = args[:exclude].upcase if args && args[:exclude]
      @gcmap_width = args[:gcmap_width] if args && args[:gcmap_width]
      @gcmap_height = args[:gcmap_height] if args && args[:gcmap_height]
    end

    # def determine_role(args)
    #   args[:atc] == false ? role = "pilot" : role = "all"
    #   args[:pilots] == false ? role = "atc" : role = role
    #   role = "all" if args[:pilots] == false && args[:atc] == false
    #   role
    # end


    def stations
      stations = []
      CSV.foreach(LOCAL_DATA, :col_sep =>':') do |row|
        callsign, origin, destination, client = row[0].to_s, row[11].to_s, row[13].to_s, row[3].to_s
        for cs in @callsign
          stations << row if callsign[0...cs.length] == cs # && client == "ATC") unless @role == "pilot"
          # stations << row if (origin[0...icao.length] == icao || destination[0...icao.length] == icao) unless @role == "atc"
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

  end

end
