module VatsimOnline
  class Station
    attr_accessor :callsign, :name, :role, :frequency, :altitude, :groundspeed, :aircraft, :departure, :destination
    attr_accessor :rating, :facility, :remarks, :route, :atis, :logon


    def initialize(station)
      self.callsign = station[0]
      self.name = station[2]
      self.role = station[3]
      self.frequency = station[4]
      self.altitude = station[7]
      self.groundspeed = station[8]
      self.aircraft = station[9]
      self.departure = station[11]
      self.destination = station[13]
      self.rating = station[16]
      self.facility = station[18]
      self.remarks = station[29]
      self.route = station[30]
      self.atis = station[35]
      self.logon = station[37]
    end

  end
end
