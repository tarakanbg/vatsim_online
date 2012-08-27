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
      new_object.latitude.should eq("2.93968")
      new_object.latitude_humanized.should eq("N2.93968")
      new_object.longitude.should eq("101.39812")
      new_object.longitude_humanized.should eq("E101.39812")
    end
  end

  describe "pilot object" do
    it "should contain all attributes" do
      gem_data_file
      icao = "EGLL"
      station = VatsimTools::StationParser.new(icao).stations.first
      new_object = VatsimTools::Station.new(station)
      new_object.callsign.should eq("AAL026")
      new_object.name.should eq("Manuel Santillan MMCU")
      new_object.role.should eq("PILOT")
      new_object.latitude.should eq("44.09780")
      new_object.latitude_humanized.should eq("N44.0978")
      new_object.longitude.should eq("-58.41483")
      new_object.longitude_humanized.should eq("W58.41483")
      new_object.planned_altitude.should eq("370")
      new_object.transponder.should eq("4122")
      new_object.heading.should eq("73")
      new_object.qnh_in.should eq("30.12")
      new_object.qnh_mb.should eq("1019")
      new_object.flight_type.should eq("I")
      new_object.cid.should eq("1210329")
    end

    it "should generate gcmap link" do
      gem_data_file
      icao = "EGLL"
      station = VatsimTools::StationParser.new(icao).stations.first
      new_object = VatsimTools::Station.new(station)
      new_object.gcmap.should eq("http://www.gcmap.com/map?P=KDFW-N44.0978+W58.41483-EGLL%2C+\"AAL026%5Cn37210+ft%5Cn543+kts\"%2B%40N44.0978+W58.41483%0d%0a&MS=wls&MR=120&MX=720x360&PM=b:disc7%2b\"%25U%25+%28N\"")
    end

  end

end
