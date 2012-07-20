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

  describe "stations" do
    args = {:pilots => true, :atc => true}
    it "should return an expected result" do
      gem_data_file
      icao = "ZGGG"
      target.new(icao, args).stations.first[0].should eq("ZGGG_ATIS")
      target.new(icao, args).stations.class.should eq(Array)
    end

    it "should distinguish roles" do
      gem_data_file
      icao = "ZGGG"
      args = {:pilots => false, :atc => true}
      target.new(icao, args).stations.first[0].should eq("ZGGG_ATIS")
      target.new(icao, args).stations.class.should eq(Array)
      args = {:pilots => true, :atc => false}
      target.new(icao, args).stations.length.should be(0)
    end

    it "should combine all stations" do
      gem_data_file
      icao = "LO"
      args = {:pilots => true, :atc => true}
      target.new(icao, args).stations.first[0].should eq("ACH0838")
      target.new(icao, args).stations.last[0].should eq("VKG342")
      target.new(icao, args).stations.last[11].should eq("LOWI")
      target.new(icao, args).stations.last[13].should eq("EKCH")
      target.new(icao, args).stations.class.should eq(Array)
      target.new(icao, args).stations.count.should eq(23)
      args = {:pilots => false, :atc => true}
      target.new(icao, args).stations.count.should eq(2)
      target.new(icao, args).stations.first[0].should eq("LOVV_CTR")
    end
  end

  describe "station_objects" do
    it "should return an array of Station objects" do
      gem_data_file
      icao = "LO"
      target.new(icao).station_objects.class.should eq(Array)
      target.new(icao).station_objects.size.should eq(23)
      args = {:pilots => false}
      target.new(icao, args).station_objects.size.should eq(2)
      args = {:atc => false}
      target.new(icao, args).station_objects.size.should eq(21)
      target.new(icao, args).station_objects.first.class.should eq(VatsimTools::Station)
      target.new(icao, args).station_objects.first.callsign.should eq("ACH0838")
    end
  end

  describe "sorted_station_objects" do
    it "should return an hash with arrays of Station objects" do
      gem_data_file
      icao = "LO"
      target.new(icao).sorted_station_objects.class.should eq(Hash)
      target.new(icao).sorted_station_objects.size.should eq(2)
      target.new(icao).sorted_station_objects[:atc].class.should eq(Array)
      target.new(icao).sorted_station_objects[:pilots].class.should eq(Array)
      target.new(icao).sorted_station_objects[:pilots].size.should eq(21)
      target.new(icao).sorted_station_objects[:atc].size.should eq(2)
      target.new(icao).sorted_station_objects[:atc].first.class.should eq(VatsimTools::Station)
      target.new(icao).sorted_station_objects[:pilots].first.callsign.should eq("ACH0838")
    end

    it "should handle roles" do
      gem_data_file
      icao = "LO"
      atc = {:pilots => false}
      pilots = {:atc => false}
      target.new(icao, atc).sorted_station_objects.class.should eq(Hash)
      target.new(icao, atc).sorted_station_objects.size.should eq(2)
      target.new(icao, atc).sorted_station_objects[:atc].class.should eq(Array)
      target.new(icao, atc).sorted_station_objects[:pilots].class.should eq(Array)

      target.new(icao, atc).sorted_station_objects[:pilots].size.should eq(0)
      target.new(icao, atc).sorted_station_objects[:atc].size.should eq(2)
      target.new(icao, pilots).sorted_station_objects[:atc].size.should eq(0)
      target.new(icao, pilots).sorted_station_objects[:pilots].size.should eq(21)
      target.new(icao, atc).sorted_station_objects[:atc].first.callsign.should eq("LOVV_CTR")
    end
  end


end
