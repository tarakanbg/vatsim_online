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
      curl = Curl::Easy.new(STATUS_URL)
      curl.timeout = 5
      curl.perform
      curl = curl.body_str
      status = Tempfile.new('vatsim_status')
      File.rename status.path, LOCAL_STATUS
      File.open(LOCAL_STATUS, "w+") {|f| f.write(curl) }
      File.chmod(0777, LOCAL_STATUS)
      dummy_status if curl.include? "<html><head>"
    rescue Curl::Err::HostResolutionError
      dummy_status
    rescue Curl::Err::TimeoutError
      dummy_status
    rescue 
      dummy_status
    rescue Exception
      dummy_status  
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
      curl = Curl::Easy.new(servers.sample)
      curl.timeout = 5
      curl.perform
      curl = curl.body_str
      data = Tempfile.new('vatsim_data', :encoding => 'utf-8')
      File.rename data.path, LOCAL_DATA
      data = curl.gsub(/["]/, '\s').encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '').encode!('UTF-8', 'UTF-16')
      File.open(LOCAL_DATA, "w+") {|f| f.write(data)}
      File.chmod(0777, LOCAL_DATA)
      gem_data_file if curl.include? "<html><head>"
    rescue Curl::Err::HostResolutionError
      gem_data_file
    rescue Curl::Err::TimeoutError
      gem_data_file
    rescue
      gem_data_file
    rescue Exception
      gem_data_file    
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

    def gem_data_file
      # path = File.realpath("lib/vatsim_online/vatsim_data.txt")
      # gem_data = File.open(path, :encoding => 'iso-8859-15').read
      # data = Tempfile.new('vatsim_data', :encoding => 'iso-8859-15')
      # data.write(gem_data.gsub(/["]/, '\s').force_encoding('iso-8859-15'))
      # File.rename data.path, "#{Dir.tmpdir}/vatsim_data.txt"

      source = File.join(Gem.loaded_specs["vatsim_online"].full_gem_path, "spec", "vatsim_data.txt")
      target = "#{Dir.tmpdir}/vatsim_data.txt"
      FileUtils.cp_r source, target

      File.chmod(0777, LOCAL_DATA)
    end

    def dummy_status
      # path = File.realpath("lib/vatsim_online/vatsim_status.txt")
      # gem_data = File.open(path, :encoding => 'iso-8859-15').read
      # data = Tempfile.new('vatsim_status', :encoding => 'iso-8859-15')
      # data.write(gem_data.gsub(/["]/, '\s').force_encoding('iso-8859-15'))
      # File.rename data.path, "#{Dir.tmpdir}/vatsim_status.txt"

      source = File.join(Gem.loaded_specs["vatsim_online"].full_gem_path, "spec", "vatsim_status.txt")
      target = "#{Dir.tmpdir}/vatsim_status.txt"
      FileUtils.cp_r source, target

      File.chmod(0777, LOCAL_STATUS)
    end


  end

end
