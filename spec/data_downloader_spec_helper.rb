def delete_local_files
  File.delete(LOCAL_STATUS) if File.exists?(LOCAL_STATUS)
  File.delete(LOCAL_DATA) if File.exists?(LOCAL_DATA)
end
