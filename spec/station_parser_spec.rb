require 'vatsim_online'
require 'station_parser_spec_helper.rb'

describe VatsimTools::StationParser do

  target = VatsimTools::StationParser

  describe "determine role" do
    it "should return a role" do
      args = {:pilots => true, :atc => true}
      target.new("loww", args).determine_role(args).should eq("all")
      args = {:pilots => true, :atc => false}
      target.new("loww", args).determine_role(args).should eq("pilot")
      args = {:pilots => false, :atc => true}
      target.new("loww", args).determine_role(args).should eq("atc")
      args = {:pilots => false, :atc => false}
      target.new("loww", args).determine_role(args).should eq("all")
    end

    it "should initialize the instance var" do
      args = {:pilots => true, :atc => true}
      target.new("loww", args).role.should eq("all")
      args = {:pilots => false, :atc => true}
      target.new("loww", args).role.should eq("atc")
    end
  end

  describe "excluded list" do
    it "should not interfere if missing" do
      args = {:exclude => "loww"}
      target.new("loww", args).role.should eq("all")
    end
  end

  describe "stations" do
    args = {:pilots => true, :atc => true}
    it "should return an expected result" do
      gem_data_file
      icao = "WMKK"
      target.new(icao, args).stations.first[0].should eq("WMKK_APP")
      target.new(icao, args).stations.class.should eq(Array)
    end

    it "should distinguish roles" do
      gem_data_file
      icao = "WMKK"
      args = {:pilots => false, :atc => true}
      target.new(icao, args).stations.first[0].should eq("WMKK_APP")
      target.new(icao, args).stations.class.should eq(Array)
      args = {:pilots => true, :atc => false}
      target.new(icao, args).stations.length.should be(0)
    end

    it "should combine all stations" do
      gem_data_file
      icao = "LO"
      args = {:pilots => true, :atc => true}
      target.new(icao, args).stations.first[0].should eq("AMZ1105")
      target.new(icao, args).stations.last[0].should eq("OS601")
      target.new(icao, args).stations.last[11].should eq("LOWW")
      target.new(icao, args).stations.last[13].should eq("UUDD")
      target.new(icao, args).stations.class.should eq(Array)
      target.new(icao, args).stations.count.should eq(12)
      args = {:pilots => false, :atc => true}
      target.new(icao, args).stations.count.should eq(0)
    end
  end

  describe "station_objects" do
    it "should return an array of Station objects" do
      gem_data_file
      icao = "LO"
      target.new(icao).station_objects.class.should eq(Array)
      target.new(icao).station_objects.size.should eq(12)
      args = {:pilots => false}
      target.new(icao, args).station_objects.size.should eq(0)
      args = {:atc => false}
      target.new(icao, args).station_objects.size.should eq(12)
      target.new(icao, args).station_objects.first.class.should eq(VatsimTools::Station)
      target.new(icao, args).station_objects.first.callsign.should eq("AMZ1105")
    end
  end

  describe "sorted_station_objects" do
    it "should return an hash with arrays of Station objects" do
      gem_data_file
      icao = "WM"
      target.new(icao).sorted_station_objects.class.should eq(Hash)
      target.new(icao).sorted_station_objects.size.should eq(4)
      target.new(icao).sorted_station_objects[:atc].class.should eq(Array)
      target.new(icao).sorted_station_objects[:pilots].class.should eq(Array)
      target.new(icao).sorted_station_objects[:pilots].size.should eq(0)
      target.new(icao).sorted_station_objects[:atc].size.should eq(4)
      target.new(icao).sorted_station_objects[:atc].first.class.should eq(VatsimTools::Station)
    end

    it "should handle roles" do
      gem_data_file
      icao = "WM"
      atc = {:pilots => false}
      pilots = {:atc => false}
      target.new(icao, atc).sorted_station_objects.class.should eq(Hash)
      target.new(icao, atc).sorted_station_objects.size.should eq(4)
      target.new(icao, atc).sorted_station_objects[:atc].class.should eq(Array)
      target.new(icao, atc).sorted_station_objects[:pilots].class.should eq(Array)

      target.new(icao, atc).sorted_station_objects[:pilots].size.should eq(0)
      target.new(icao, atc).sorted_station_objects[:atc].size.should eq(4)
      target.new(icao, pilots).sorted_station_objects[:atc].size.should eq(0)
      target.new(icao, pilots).sorted_station_objects[:pilots].size.should eq(0)
      target.new(icao, atc).sorted_station_objects[:atc].first.callsign.should eq("WMKK_APP")
    end

    it "should recognize arrivals and departures" do
      gem_data_file
      icao = "LO"
      target.new(icao).sorted_station_objects[:pilots].size.should eq(12)
      target.new(icao).sorted_station_objects[:pilots].size.should eq(target.new(icao).sorted_station_objects[:arrivals].size + target.new(icao).sorted_station_objects[:departures].size)
      target.new(icao).sorted_station_objects[:arrivals].size.should eq(6)
      target.new(icao).sorted_station_objects[:departures].size.should eq(6)
    end

    it "should recognize exclusions" do
      gem_data_file
      icao = "LB"
      target.new(icao).sorted_station_objects[:atc].size.should eq(4)
      args = {:exclude => "LBGO"}
      target.new(icao, args).excluded.should eq("LBGO")
      target.new(icao, args).excluded.length.should eq(4)
      target.new(icao, args).sorted_station_objects[:atc].size.should eq(3)
      args = {:exclude => "LBSF"}
      target.new(icao, args).sorted_station_objects[:atc].size.should eq(2)
      args = {:exclude => "lbsf"}
      target.new(icao, args).sorted_station_objects[:atc].size.should eq(2)
    end

    it "should support multiple icaos" do
      gem_data_file
      icao = "LB"
      target.new(icao).sorted_station_objects[:atc].size.should eq(4)
      target.new(icao).sorted_station_objects[:pilots].size.should eq(2)
      icao = "LO"
      target.new(icao).sorted_station_objects[:pilots].size.should eq(12)
      target.new(icao).sorted_station_objects[:atc].size.should eq(0)
      gem_data_file
      icao = "LO,LB"
      target.new(icao).sorted_station_objects[:pilots].size.should eq(14)
      target.new(icao).sorted_station_objects[:atc].size.should eq(4)
      icao = "LO, LB"
      target.new(icao).sorted_station_objects[:pilots].size.should eq(14)
      target.new(icao).sorted_station_objects[:atc].size.should eq(4)
      icao = "LO , LB"
      target.new(icao).sorted_station_objects[:pilots].size.should eq(14)
      target.new(icao).sorted_station_objects[:arrivals].size.should eq(7)
      target.new(icao).sorted_station_objects[:departures].size.should eq(7)
      target.new(icao).sorted_station_objects[:atc].size.should eq(4)
    end

  end

end
