%w{curb csv tempfile tmpdir time_diff vatsim_online/version
   vatsim_online/station vatsim_online/data_downloader}.each { |lib| require lib }

class String
  def vatsim_online(args={})
    VatsimOnline.vatsim_online(self, args)
  end
end

module VatsimOnline

  def self.vatsim_online(icao, args)
  end


private

  def self.stations(icao, role = "all")
    stations = []
    CSV.foreach(self.data_file, :col_sep =>':', :row_sep =>:auto, encoding: "iso-8859-15") do |row|
      callsign = row[0]; origin = row[11]; destination = row[13]; client = row[3]
      stations << row if (callsign.to_s[0..get_query_length(icao)] == icao && client == "ATC") unless role == "pilot"
      stations << row if (origin.to_s[0..get_query_length(icao)] == icao || destination.to_s[0..get_query_length(icao)] == icao) unless role == "atc"
    end
    return stations
  end

  def self.get_query_length(icao)
    icao.length - 1
  end

  def self.station_objects(icao, role = "all")
    station_objects= []
    self.stations(icao, role).each {|station| station_objects << VatsimOnline::Station.new(station) }
    return station_objects
  end

  def self.sort_station_objects(icao, role = "all")
    atc = []; pilots = []
    self.station_objects(icao, role).each {|sobj| sobj.role == "ATC" ? atc << sobj : pilots << sobj}
    return {:atc => atc, :pilots => pilots}
  end

  def self.determine_role(args)
    args[:atc] == false ? role = "pilot" : role = "all"
    args[:pilots] == false ? role = "atc" : role = role
    role = "all" if args[:pilots] == false && args[:atc] == false
    return role
  end

end
