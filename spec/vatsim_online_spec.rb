require 'spec_helper.rb'

data = VatsimOnline.data_file

describe VatsimOnline do

  describe "servers" do
    it "should contain an array of server URLs" do
      VatsimOnline.servers.class.should eq(Array)
      VatsimOnline.servers.size.should eq(5)
    end
  end

  describe "data_file" do
    it "should contain file path" do
      VatsimOnline.data_file.class.should eq(String)
      VatsimOnline.data_file.should include("vatsim_data.txt")
    end
  end

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




end
