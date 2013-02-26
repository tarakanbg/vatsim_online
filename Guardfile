guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch('lib/vatsim_online/version.rb') 
  watch('lib/vatsim_online/station.rb') 
  watch('lib/vatsim_online/data_downloader.rb') 
  watch('lib/vatsim_online/station_parser.rb') 
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^lib/vatsim_online/(.+)\.rb$})
  watch('spec/spec_helper.rb')  { "spec" }
end
