%w{vatsim_online/version vatsim_online/station vatsim_online/data_downloader
   vatsim_online/station_parser}.each { |lib| require lib }

class String
  def vatsim_online(args={})
    VatsimOnline.vatsim_online(self, args)
  end
end

module VatsimOnline

  def self.vatsim_online(icao, args)
  end


end
