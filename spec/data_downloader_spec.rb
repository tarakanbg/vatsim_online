require 'spec_helper.rb'
require 'data_downloader_spec_helper.rb'

describe VatsimTools::DataDownloader do

  TARGET = VatsimTools::DataDownloader
  LOCAL_STATUS = "#{Dir.tmpdir}/vatsim_status.txt"
  LOCAL_DATA = "#{Dir.tmpdir}/vatsim_data.txt"

  describe "create_status_tempfile" do
    it "should create a file" do
      delete_local_files
      File.exists?(LOCAL_STATUS).should be false
      TARGET.new.create_status_tempfile
      File.exists?(LOCAL_STATUS).should be true
      File.open(LOCAL_STATUS).path.should eq("#{Dir.tmpdir}/vatsim_status.txt")
      File.open(LOCAL_STATUS).size.should be > 100
    end
  end

  describe "read_status_tempfile" do
    it "should confirm a file exists" do
      TARGET.new.read_status_tempfile
      File.exists?(LOCAL_STATUS).should be true
      File.open(LOCAL_STATUS).size.should be > 100
    end
  end

  describe "status_file" do
    it "should return status.txt path" do
      delete_local_files
      File.exists?(LOCAL_STATUS).should be false
      TARGET.new.status_file.class.should eq(String)
      TARGET.new.status_file.should include("vatsim_status.txt")
      TARGET.new.status_file.should eq(LOCAL_STATUS)
      TARGET.new.status_file.should eq("#{Dir.tmpdir}/vatsim_status.txt")
      File.exists?(LOCAL_STATUS).should be true
    end
  end

  describe "servers" do
    it "should contain an array of server URLs" do
      File.exists?(LOCAL_STATUS).should be true
      TARGET.new.servers.class.should eq(Array)
      TARGET.new.servers.size.should eq(5)
    end
  end

  describe "create_local_data_file" do
    it "should confirm a file exists" do
      TARGET.new.create_local_data_file
      File.exists?(LOCAL_DATA).should be true
      File.open(LOCAL_DATA).path.should eq("#{Dir.tmpdir}/vatsim_data.txt")
      File.open(LOCAL_DATA).size.should be > 100
    end
  end

  describe "read_local_datafile" do
    it "should confirm a file exists" do
      TARGET.new.read_local_datafile
      File.exists?(LOCAL_DATA).should be true
      File.open(LOCAL_DATA).size.should be > 100
    end
  end

  describe "data_file" do
    it "should contain file path" do
      delete_local_files
      File.exists?(LOCAL_DATA).should be false
      TARGET.new.data_file.class.should eq(String)
      TARGET.new.data_file.should include("vatsim_data.txt")
      TARGET.new.data_file.should eq(LOCAL_DATA)
      TARGET.new.data_file.should eq("#{Dir.tmpdir}/vatsim_data.txt")
      File.exists?(LOCAL_DATA).should be true
    end
  end

  describe "new" do
    it "should return" do
      delete_local_files
      File.exists?(LOCAL_DATA).should be false
      File.exists?(LOCAL_STATUS).should be false
      TARGET.new
      File.exists?(LOCAL_DATA).should be true
      File.exists?(LOCAL_STATUS).should be true
      File.open(LOCAL_DATA).size.should be > 100
      File.open(LOCAL_STATUS).size.should be > 100
    end
  end

end
