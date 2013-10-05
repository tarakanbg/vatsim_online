require 'vatsim_online'
require 'callsign_parser_spec_helper.rb'

describe VatsimTools::CallsignParser do

  target = VatsimTools::CallsignParser

  describe "stations" do
    it "should return an expected result" do
      gem_data_file
      callsign = "WMKK"
      target.new(callsign).stations.first[0].should eq("WMKK_APP")
      target.new(callsign).stations.class.should eq(Array)
    end   
  end

  describe "station_objects" do
    it "should return an array of Station objects" do
      gem_data_file
      callsign = "LO"
      target.new(callsign).station_objects.class.should eq(Array)
      target.new(callsign).station_objects.size.should eq(2)
      target.new(callsign).station_objects.first.class.should eq(VatsimTools::Station)
      target.new(callsign).station_objects.first.callsign.should eq("LOT282")
    end
  end

  
end
