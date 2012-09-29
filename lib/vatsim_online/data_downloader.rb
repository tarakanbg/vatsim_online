module VatsimTools

  class DataDownloader

    %w{curb tempfile time_diff tmpdir csv}.each { |lib| require lib }

    STATUS_URL = "http://status.vatsim.net/status.txt"
    LOCAL_STATUS = "#{Dir.tmpdir}/vatsim_status.txt"
    LOCAL_DATA = "#{Dir.tmpdir}/vatsim_data.txt"

    def initialize
      data_file
    end

    def create_status_tempfile
      status = Tempfile.new('vatsim_status')
      File.rename status.path, LOCAL_STATUS
      File.open(LOCAL_STATUS, "w+") {|f| f.write(Curl::Easy.perform(STATUS_URL).body_str) }
      File.chmod(0777, LOCAL_STATUS)
    end

    def read_status_tempfile
      status = File.open(LOCAL_STATUS)
      difference = Time.diff(status.ctime, Time.now)[:hour]
      difference > 3 ? create_status_tempfile : status.read
    end

    def status_file
      File.exists?(LOCAL_STATUS) ? read_status_tempfile : create_status_tempfile
      LOCAL_STATUS
    end

    def servers
      urls = []
      CSV.foreach(status_file, :col_sep =>'=') {|row| urls << row[1] if row[0] == "url0"}
      urls
    end

    def create_local_data_file
      data = Tempfile.new('vatsim_data', :encoding => 'utf-8')
      File.rename data.path, LOCAL_DATA
      data = Curl::Easy.perform(servers.sample).body_str.gsub(/["]/, '\s').encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '').encode!('UTF-8', 'UTF-16')
      File.open(LOCAL_DATA, "w+") {|f| f.write(data)}
      File.chmod(0777, LOCAL_DATA)
    end

    def read_local_datafile
      data = File.open(LOCAL_DATA)
      difference = Time.diff(data.ctime, Time.now)[:minute]
      difference > 2 ? create_local_data_file : data.read
    end

    def data_file
      File.exists?(LOCAL_DATA) ? read_local_datafile : create_local_data_file
      LOCAL_DATA
    end

  end

end
