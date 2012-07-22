require 'spec_helper.rb'

describe VatsimOnline do

  describe "vatsim_online" do
    it "should work :)" do
      gem_data_file
      "ZGGG".vatsim_online.class.should eq(Hash)
      "LO".vatsim_online.class.should eq(Hash)
      "WM".vatsim_online[:atc].size.should eq(4)
      "LO".vatsim_online[:pilots].size.should eq(12)
      "LO".vatsim_online(:pilots => true, :atc => true).class.should eq(Hash)
      "LO".vatsim_online(:pilots => true, :atc => true)[:atc].size.should eq(0)
      "LO".vatsim_online(:pilots => true, :atc => true)[:pilots].size.should eq(12)
      "LO".vatsim_online(:atc => false)[:atc].size.should eq(0)
      "LO".vatsim_online(:atc => false)[:pilots].size.should eq(12)
      "WM".vatsim_online(:pilots => false)[:atc].size.should eq(4)
      "LO".vatsim_online(:pilots => false)[:pilots].size.should eq(0)

      "LO".vatsim_online[:pilots].first.callsign.should eq("AMZ1105")
      "WM".vatsim_online[:atc].first.callsign.should eq("WMKK_APP")
    end

    it "should be case insensitive" do
      gem_data_file
      "wm".vatsim_online[:atc].size.should eq(4)
      "lo".vatsim_online[:pilots].size.should eq(12)
      "wm".vatsim_online(:pilots => true, :atc => true)[:atc].size.should eq(4)
      "lo".vatsim_online(:pilots => true, :atc => true)[:pilots].size.should eq(12)
    end
  end

end


describe VatsimTools::Station do

  describe "new object" do
    it "should return proper attributes" do
      gem_data_file
      icao = "WMKK"
      station = VatsimTools::StationParser.new(icao).stations.first
      new_object = VatsimTools::Station.new(station)
      new_object.callsign.should eq("WMKK_APP")
      new_object.name.should eq("Adriel Loke")
      new_object.role.should eq("ATC")
      new_object.frequency.should eq("124.200")
      new_object.rating.should eq("3")
      new_object.facility.should eq("5")
      new_object.logon.should eq("20120722092836")
    end
  end

end
