require 'spec_helper.rb'

describe VatsimOnline do

  # describe "create_status_tempfile" do
  #   it "should create a file" do
  #     VatsimOnline.create_status_tempfile
  #     File.exists?("#{Dir.tmpdir}/vatsim_status.txt").should be true
  #   end
  # end

  describe "read_status_tempfile" do
    it "should confirm a file exists" do
      VatsimOnline.read_status_tempfile
      File.exists?("#{Dir.tmpdir}/vatsim_status.txt").should be true
    end
  end

  describe "status_file" do
    it "should return status.txt path" do
      VatsimOnline.status_file.class.should eq(String)
      VatsimOnline.status_file.should include("vatsim_status.txt")
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

  describe "read_data_tempfile" do
    it "should confirm a file exists" do
      VatsimOnline.read_local_datafile
      File.exists?("#{Dir.tmpdir}/vatsim_data.txt").should be true
    end
  end

  describe "data_file" do
    it "should contain file path" do
      data = VatsimOnline.data_file
      VatsimOnline.data_file.class.should eq(String)
      VatsimOnline.data_file.should include("vatsim_data.txt")
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
