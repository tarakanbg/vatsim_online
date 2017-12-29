module VatsimTools

  class DataDownloader

    %w{tempfile time_diff tmpdir csv net/http}.each { |lib| require lib }

    STATUS_URL = "http://status.vatsim.net/status.txt"
    LOCAL_STATUS = "#{Dir.tmpdir}/vatsim_status.txt"
    LOCAL_STATUS_BAK = "#{Dir.tmpdir}/vatsim_status_bak.txt"
    LOCAL_DATA = "#{Dir.tmpdir}/vatsim_data.txt"
    LOCAL_DATA_BAK = "#{Dir.tmpdir}/vatsim_data_bak.txt"

    def initialize
      data_file
    end

    def create_status_tempfile
      curl = get_data(STATUS_URL)
      curl.gsub!("\n", '')
      create_status_backup if File.exists?(LOCAL_STATUS)
      status = Tempfile.new('vatsim_status')
      status.close
      File.rename status.path, LOCAL_STATUS
      File.open(LOCAL_STATUS, "w+") {|f| f.write(curl) }
      File.chmod(0777, LOCAL_STATUS)
      dummy_status if curl.include? "<html><head>"
    rescue Net::HTTPNotFound
      dummy_status
    rescue Net::HTTPRequestTimeOut
      dummy_status
    rescue
      dummy_status
    rescue Exception
      dummy_status
    end

    def create_status_backup
      source = LOCAL_STATUS
      target = LOCAL_STATUS_BAK
      FileUtils.cp_r source, target
      File.chmod(0777, LOCAL_STATUS_BAK)
    end

    def read_status_tempfile
      status = File.open(LOCAL_STATUS)
      difference = Time.diff(status.ctime, Time.now)[:hour]
      difference > 3 ? create_status_tempfile : status.read
      status.close
    end

    def status_file
      File.exists?(LOCAL_STATUS) ? read_status_tempfile : create_status_tempfile
      LOCAL_STATUS
    end

    def servers
      urls = []
      CSV.foreach(status_file, :col_sep =>'=') do |row|
        urls << row[1] if row[0] == "url0"
      end
      urls
    end

    def create_local_data_file
      curl = get_data(servers.sample)
      curl.gsub!("\n", '')
      create_data_backup if File.exists?(LOCAL_DATA)
      data = Tempfile.new('vatsim_data', :encoding => 'utf-8')
      data.close
      File.rename data.path, LOCAL_DATA
      data = curl.gsub(/["]/, '\s').encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '').encode!('UTF-8', 'UTF-16')
      data = data.slice(0..(data.index('!PREFILE:')))
      File.open(LOCAL_DATA, "w+") {|f| f.write(data)}
      File.chmod(0777, LOCAL_DATA)
      gem_data_file if curl.include? "<html><head>"
      data_file = File.open(LOCAL_DATA)
      gem_data_file if data_file.size == 0
      data_file.close
    rescue Net::HTTPNotFound
      gem_data_file
    rescue Net::HTTPRequestTimeOut
      gem_data_file
    rescue
      gem_data_file
    rescue Exception
      gem_data_file
    end

    def create_data_backup
      source = LOCAL_DATA
      target = LOCAL_DATA_BAK
      FileUtils.cp_r source, target
      File.chmod(0777, LOCAL_DATA_BAK)
    end

    def read_local_datafile
      data = File.open(LOCAL_DATA)
      difference = Time.diff(data.ctime, Time.now)[:minute]
      difference > 2 ? create_local_data_file : data.read
      data.close
    end

    def data_file
      File.exists?(LOCAL_DATA) ? read_local_datafile : create_local_data_file
      LOCAL_DATA
    end

    def gem_data_file
      source = LOCAL_DATA_BAK
      target = LOCAL_DATA
      FileUtils.cp_r source, target
      File.chmod(0777, LOCAL_DATA)
    end

    def dummy_status
      source = LOCAL_STATUS_BAK
      target = LOCAL_STATUS
      FileUtils.cp_r source, target
      File.chmod(0777, LOCAL_STATUS)
    end
    def get_data(url)
      uri = URI(url)
      Net::HTTP.get(uri)
    end
  end

end
