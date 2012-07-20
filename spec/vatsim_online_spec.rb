require 'spec_helper.rb'

describe VatsimOnline do

  describe "vatsim_online" do
    it "should work :)" do
      gem_data_file
      "ZGGG".vatsim_online.class.should eq(Has)
    end
  end

end


describe VatsimTools::Station do

  describe "new object" do
    it "should return proper attributes" do
      gem_data_file
      icao = "ZGGG"
      station = VatsimTools::StationParser.new(icao).stations.first
      new_object = VatsimTools::Station.new(station)
      new_object.callsign.should eq("ZGGG_ATIS")
      new_object.name.should eq("Yu Xiong")
      new_object.role.should eq("ATC")
      new_object.frequency.should eq("127.000")
      new_object.rating.should eq("3")
      new_object.facility.should eq("4")
      new_object.logon.should eq("20120713151529")
    end
  end

end
