def gem_data_file
  path = File.realpath("spec/vatsim_data.txt")
  gem_data = File.open(path, :encoding => 'iso-8859-15').read
  data = Tempfile.new('vatsim_data', :encoding => 'iso-8859-15')
  data.write(gem_data.gsub(/["]/, '\s').force_encoding('iso-8859-15'))
  File.rename data.path, "#{Dir.tmpdir}/vatsim_data.txt"
end
