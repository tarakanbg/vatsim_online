%w{vatsim_online/version vatsim_online/station vatsim_online/data_downloader
   vatsim_online/station_parser vatsim_online/callsign_parser}.each { |lib| require lib }

class String
  def vatsim_online(args={})
    VatsimOnline.vatsim_online(self, args)
  end

  def vatsim_callsign(args={})
    VatsimOnline.vatsim_callsign(self, args)
  end
end

module VatsimOnline

  def self.vatsim_online(icao, args)
    VatsimTools::StationParser.new(icao,args).sorted_station_objects
  end

  def self.vatsim_callsign(callsign, args)
    VatsimTools::CallsignParser.new(callsign,args).station_objects
  end

end
