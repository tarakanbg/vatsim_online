require 'spec_helper.rb'

describe VatsimOnline do

  # describe "create_status_tempfile" do
  #   it "should create a file" do
  #     VatsimOnline.create_status_tempfile
  #     File.exists?("#{Dir.tmpdir}/vatsim_status.txt").should be true
  #   end
  # end

  describe "status_file" do
    it "should return status.txt path" do
      VatsimOnline.status_file.class.should eq(String)
      VatsimOnline.status_file.should include("vatsim_status.txt")
    end
  end

  describe "read_status_tempfile" do
    it "should confirm a file exists" do
      VatsimOnline.read_status_tempfile
      File.exists?("#{Dir.tmpdir}/vatsim_status.txt").should be true
    end
  end


  describe "servers" do
    it "should contain an array of server URLs" do
      VatsimOnline.servers.class.should eq(Array)
      VatsimOnline.servers.size.should eq(5)
    end
  end

  # describe "create_data_tempfile" do
  #   it "should confirm a file exists" do
  #     VatsimOnline.create_local_data_file
  #     File.exists?("#{Dir.tmpdir}/vatsim_data.txt").should be true
  #   end
  # end

  describe "data_file" do
    it "should contain file path" do
      data = VatsimOnline.data_file
      VatsimOnline.data_file.class.should eq(String)
      VatsimOnline.data_file.should include("vatsim_data.txt")
    end
  end

  describe "read_data_tempfile" do
    it "should confirm a file exists" do
      VatsimOnline.read_local_datafile
      File.exists?("#{Dir.tmpdir}/vatsim_data.txt").should be true
    end
  end

  describe "get_query_length" do
    it "should calculate" do
      icao = "lqsa"
      VatsimOnline.get_query_length(icao).should eq(3)
      icao = "lq"
      VatsimOnline.get_query_length(icao).should eq(1)
    end
  end

  describe "stations" do
    it "should return an expected result" do
      gem_data_file
      icao = "ZGGG"
      VatsimOnline.stations(icao).first[0].should eq("ZGGG_ATIS")
      VatsimOnline.stations(icao).class.should eq(Array)
    end

    it "should distinguish roles" do
      gem_data_file
      icao = "ZGGG"
      VatsimOnline.stations(icao, role="atc").first[0].should eq("ZGGG_ATIS")
      VatsimOnline.stations(icao, role="atc").class.should eq(Array)
      VatsimOnline.stations(icao, role="pilot").length.should be(0)
    end

    it "should combine all stations" do
      gem_data_file
      icao = "LO"
      VatsimOnline.stations(icao).first[0].should eq("ACH0838")
      VatsimOnline.stations(icao).last[0].should eq("VKG342")
      VatsimOnline.stations(icao).last[11].should eq("LOWI")
      VatsimOnline.stations(icao).last[13].should eq("EKCH")
      VatsimOnline.stations(icao).class.should eq(Array)
      VatsimOnline.stations(icao).count.should eq(23)
      VatsimOnline.stations(icao, role = "atc").count.should eq(2)
      VatsimOnline.stations(icao, role = "atc").first[0].should eq("LOVV_CTR")
    end
  end

  describe "station_objects" do
    it "should return an array of Station objects" do
      gem_data_file
      icao = "LO"
      VatsimOnline.station_objects(icao).class.should eq(Array)
      VatsimOnline.station_objects(icao).size.should eq(23)
      VatsimOnline.station_objects(icao, role="atc").size.should eq(2)
      VatsimOnline.station_objects(icao, role="pilot").size.should eq(21)
      VatsimOnline.station_objects(icao).first.class.should eq(VatsimOnline::Station)
      VatsimOnline.station_objects(icao).first.callsign.should eq("ACH0838")
    end
  end

  describe "sort_station_objects" do
    it "should return an hash with arrays of Station objects" do
      gem_data_file
      icao = "LO"
      VatsimOnline.sort_station_objects(icao).class.should eq(Hash)
      VatsimOnline.sort_station_objects(icao).size.should eq(2)
      VatsimOnline.sort_station_objects(icao)[:atc].class.should eq(Array)
      VatsimOnline.sort_station_objects(icao)[:pilots].class.should eq(Array)
      VatsimOnline.sort_station_objects(icao)[:pilots].size.should eq(21)
      VatsimOnline.sort_station_objects(icao)[:atc].size.should eq(2)
      VatsimOnline.sort_station_objects(icao)[:atc].first.class.should eq(VatsimOnline::Station)
      VatsimOnline.sort_station_objects(icao)[:pilots].first.callsign.should eq("ACH0838")
    end

    it "should handle roles" do
      gem_data_file
      icao = "LO"
      VatsimOnline.sort_station_objects(icao, role="atc").class.should eq(Hash)
      VatsimOnline.sort_station_objects(icao, role="atc").size.should eq(2)
      VatsimOnline.sort_station_objects(icao, role="atc")[:atc].class.should eq(Array)
      VatsimOnline.sort_station_objects(icao, role="atc")[:pilots].class.should eq(Array)

      VatsimOnline.sort_station_objects(icao, role="atc")[:pilots].size.should eq(0)
      VatsimOnline.sort_station_objects(icao, role="atc")[:atc].size.should eq(2)
      VatsimOnline.sort_station_objects(icao, role="pilot")[:atc].size.should eq(0)
      VatsimOnline.sort_station_objects(icao, role="pilot")[:pilots].size.should eq(21)
      VatsimOnline.sort_station_objects(icao, role="atc")[:atc].first.callsign.should eq("LOVV_CTR")
    end
  end

  describe "determine role" do
    it "should return a role" do
      args = {:pilots => true, :atc => true}
      VatsimOnline.determine_role(args).should eq("all")
      args = {:pilots => true, :atc => false}
      VatsimOnline.determine_role(args).should eq("pilot")
      args = {:pilots => false, :atc => true}
      VatsimOnline.determine_role(args).should eq("atc")
      args = {:pilots => false, :atc => false}
      VatsimOnline.determine_role(args).should eq("all")
    end
  end

end


describe VatsimOnline::Station do

  describe "new object" do
    it "should return proper attributes" do
      gem_data_file
      icao = "ZGGG"
      station = VatsimOnline.stations(icao).first
      new_object = VatsimOnline::Station.new(station)
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
