require "vatsim_online/version"
require "curb"
require "csv"
require 'tempfile'
require "tmpdir"

module VatsimOnline

private

  def self.status_file
    Curl::Easy.perform("http://status.vatsim.net/status.txt").body_str
  end

  def self.create_status_tempfile
    status = Tempfile.new('vatsim_status')
    status.write(self.status_file)
    status.rewind
    File.rename status.path, "#{Dir.tmpdir}/vatsim_status.txt"
    status.read
  end

  def self.read_status_tempfile
    status = File.open("#{Dir.tmpdir}/vatsim_status.txt")
    status.read
  end

  def self.servers
    ["http://www.net-flyer.net/DataFeed/vatsim-data.txt",
    "http://www.klain.net/sidata/vatsim-data.txt",
    "http://fsproshop.com/servinfo/vatsim-data.txt",
    "http://info.vroute.net/vatsim-data.txt",
    "http://data.vattastic.com/vatsim-data.txt"]
  end

  def self.pick_random_server
    self.servers.sample
  end

  def self.data_file
    Curl::Easy.perform(self.pick_random_server).body_str
  end

  def self.csv_data
    CSV.new(self.data_file, :col_sep =>':', :row_sep =>:auto)
  end
end
