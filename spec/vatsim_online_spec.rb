require 'spec_helper.rb'
require 'vatsim_online_spec_helper.rb'

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
      "LO".vatsim_online(:gcmap_width => "400", :gcmap_height => "400")[:pilots].first.gcmap.should eq("http://www.gcmap.com/map?P=LOWW-N45.45676+E12.28972-LIPZ%2C+\"AMZ1105%5Cn1007+ft%5Cn128+kts\"%2B%40N45.45676+E12.28972%0d%0a&MS=wls&MR=120&MX=400x400&PM=b:disc7%2b\"%25U%25+%28N\"")
      "LO".vatsim_online(:gcmap_width => 400, :gcmap_height => 400)[:pilots].first.gcmap.should eq("http://www.gcmap.com/map?P=LOWW-N45.45676+E12.28972-LIPZ%2C+\"AMZ1105%5Cn1007+ft%5Cn128+kts\"%2B%40N45.45676+E12.28972%0d%0a&MS=wls&MR=120&MX=400x400&PM=b:disc7%2b\"%25U%25+%28N\"")
    end

    it "should be case insensitive" do
      gem_data_file
      "wm".vatsim_online[:atc].size.should eq(4)
      "lo".vatsim_online[:pilots].size.should eq(12)
      "wm".vatsim_online(:pilots => true, :atc => true)[:atc].size.should eq(4)
      "lo".vatsim_online(:pilots => true, :atc => true)[:pilots].size.should eq(12)
    end
  end

  describe "vatsim_callsign" do
    it "should work :)" do
      gem_data_file
      "AMZ1105".vatsim_callsign.class.should eq(Array)
      "AMZ1105".vatsim_callsign.size.should eq(1)
      "AMZ1105".vatsim_callsign.first.callsign.should eq("AMZ1105")      
      "BAW".vatsim_callsign.size.should eq(15)
      "BAW".vatsim_callsign.last.callsign.should eq("BAW9DV")      
      "BAW, AMZ1105".vatsim_callsign.size.should eq(16)
      "BAW, QFA".vatsim_callsign.size.should eq(21)
      
    end

    it "should be case insensitive" do
      gem_data_file
      "amz1105".vatsim_callsign.first.callsign.should eq("AMZ1105")
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
      new_object.rating.should eq("S2")
      new_object.facility.should eq("5")
      new_object.logon.should eq("20120722092836")
      new_object.latitude.should eq("2.93968")
      new_object.latitude_humanized.should eq("N2.93968")
      new_object.longitude.should eq("101.39812")
      new_object.longitude_humanized.should eq("E101.39812")
    end

    it "should parse Ruby time with online_since attr" do
      gem_data_file
      icao = "LBWN"
      station = VatsimTools::StationParser.new(icao).sorted_station_objects[:atc].first
      station.logon.should eq("20120722091954")
      station.online_since.class.should eq(Time)
      station.online_since.utc?.should eq(true)
      station.online_since.should eq("2012-07-22 09:19:54 UTC")
      station.rating.should eq("INS")
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

    it "should handle resized gcmap" do
      gem_data_file
      icao = "EGLL"
      args = {}
      args[:gcmap_width] = "400"
      args[:gcmap_height] = "400"
      station = VatsimTools::StationParser.new(icao).stations.first
      new_object = VatsimTools::Station.new(station, args)
      new_object.gcmap_width.should eq(400)
      new_object.gcmap_height.should eq(400)
      new_object.gcmap.should eq("http://www.gcmap.com/map?P=KDFW-N44.0978+W58.41483-EGLL%2C+\"AAL026%5Cn37210+ft%5Cn543+kts\"%2B%40N44.0978+W58.41483%0d%0a&MS=wls&MR=120&MX=400x400&PM=b:disc7%2b\"%25U%25+%28N\"")

    end

  end

  describe "atc object" do
    it "should handle regular and humanized atis" do
      gem_data_file
      icao = "LBWN"
      station = VatsimTools::StationParser.new(icao).sorted_station_objects[:atc].first
      station.logon.should eq("20120722091954")
      station.rating.should eq("INS")
      station.atis.should eq("$ voice2.vacc-sag.org/lfmn_app. Nice Approach. Charts at www.tinyurl.com/chartsfr. Visit www.vatfrance.org")
      station.atis_message.should eq("Nice Approach<br />Charts at www.tinyurl.com/chartsfr<br />Visit www.vatfrance.org")
    end

     it "should handle no ATC remark" do
      gem_data_file
      icao = "NZAA"
      station = VatsimTools::StationParser.new(icao).sorted_station_objects[:atc].first
      station.atis.should eq("$ rw1.vatpac.org/nzaa_twr")
      station.atis_message.should eq("No published remark")
    end
  end

end
