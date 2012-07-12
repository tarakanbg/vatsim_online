require 'spec_helper.rb'

data = VatsimOnline.data_file

describe VatsimOnline do

  describe "servers" do
    it "should contain an array of server URLs" do
      VatsimOnline.servers.class.should eq(Array)
      VatsimOnline.servers.size.should eq(5)
    end
  end

  describe "pick_random_server" do
    it "should return a string with an URL" do
      VatsimOnline.pick_random_server.class.should eq(String)
      VatsimOnline.pick_random_server[0..6].should eq("http://")
    end
  end

  describe "data_file" do
    it "should contain the right text" do
      data[0..11].should eq("; Created at")
    end
  end

  describe "csv_data" do
    it "should convert to a valid CSV" do
      VatsimOnline.csv_data.class.should eq(CSV)
    end
  end

  # describe "create_status_tempfile" do
  #   it "should return a status.txt contents" do
  #     VatsimOnline.create_status_tempfile.class.should eq(String)
  #     VatsimOnline.create_status_tempfile[0..16].should eq("; IMPORTANT NOTE:")
  #   end
  # end

  describe "read_status_tempfile" do
    it "should return a status.txt contents" do
      VatsimOnline.read_status_tempfile.class.should eq(String)
      VatsimOnline.read_status_tempfile[0..16].should eq("; IMPORTANT NOTE:")
    end
  end


end
