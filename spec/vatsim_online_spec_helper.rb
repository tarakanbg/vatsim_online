def gem_data_file
  path = File.realpath("spec/vatsim_data.txt")
  data_file = File.open(path, :encoding => 'iso-8859-15')
  gem_data = data_file.read
  data_file.close
  data = Tempfile.new('vatsim_data', :encoding => 'iso-8859-15')
  data.write(gem_data.gsub(/["]/, '\s').force_encoding('iso-8859-15'))
  data.close
  File.rename data.path, "#{Dir.tmpdir}/vatsim_data.txt"
end
