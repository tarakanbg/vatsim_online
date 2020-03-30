require 'spec_helper.rb'
require 'data_downloader_spec_helper.rb'

describe VatsimTools::DataDownloader do

  target = VatsimTools::DataDownloader
  LOCAL_STATUS = "#{Dir.tmpdir}/vatsim_status.txt"
  LOCAL_DATA = "#{Dir.tmpdir}/vatsim_data.txt"

  describe "create_status_tempfile" do
    it "should create a file" do
      delete_local_files
      File.exists?(LOCAL_STATUS).should be false
      target.new.create_status_tempfile
      File.exists?(LOCAL_STATUS).should be true
      status = File.open(LOCAL_STATUS)
      status.path.should eq("#{Dir.tmpdir}/vatsim_status.txt")
      status.size.should be > 100
      status.close
    end
  end

  describe "read_status_tempfile" do
    it "should confirm a file exists" do
      target.new.read_status_tempfile
      File.exists?(LOCAL_STATUS).should be true
      status = File.open(LOCAL_STATUS)
      status.size.should be > 100
      status.close
    end
  end

  describe "status_file" do
    it "should return status.txt path" do
      delete_local_files
      File.exists?(LOCAL_STATUS).should be false
      target.new.status_file.class.should eq(String)
      target.new.status_file.should include("vatsim_status.txt")
      target.new.status_file.should eq(LOCAL_STATUS)
      target.new.status_file.should eq("#{Dir.tmpdir}/vatsim_status.txt")
      File.exists?(LOCAL_STATUS).should be true
    end
  end

  describe "servers" do
    it "should contain an array of server URLs" do
      File.exists?(LOCAL_STATUS).should be true
      target.new.servers.class.should eq(Array)
      target.new.servers.size.should eq(5)
    end
  end

  describe "create_local_data_file" do
    it "should confirm a file exists" do
      delete_local_files
      File.exists?(LOCAL_DATA).should be false
      target.new.create_local_data_file
      File.exists?(LOCAL_DATA).should be true
      data = File.open(LOCAL_DATA)
      data.path.should eq("#{Dir.tmpdir}/vatsim_data.txt")
      data.size.should be > 100
      data.close
    end
  end

  describe "read_local_datafile" do
    it "should confirm a file exists" do
      target.new.read_local_datafile
      File.exists?(LOCAL_DATA).should be true
      data = File.open(LOCAL_DATA)
      data.size.should be > 100
      data.close
    end
  end

  describe "data_file" do
    it "should contain file path" do
      delete_local_files
      File.exists?(LOCAL_DATA).should be false
      target.new.data_file.class.should eq(String)
      target.new.data_file.should include("vatsim_data.txt")
      target.new.data_file.should eq(LOCAL_DATA)
      target.new.data_file.should eq("#{Dir.tmpdir}/vatsim_data.txt")
      File.exists?(LOCAL_DATA).should be true
    end
  end

  describe "new" do
    it "should return" do
      delete_local_files
      File.exists?(LOCAL_DATA).should be false
      File.exists?(LOCAL_STATUS).should be false
      target.new
      File.exists?(LOCAL_DATA).should be true
      File.exists?(LOCAL_STATUS).should be true
      data = File.open(LOCAL_DATA)
      status = File.open(LOCAL_DATA)
      data.size.should be > 100
      status.size.should be > 100
      status.close
      data.close
    end
  end

end
