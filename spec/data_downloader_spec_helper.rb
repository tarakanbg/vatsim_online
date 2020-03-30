def delete_local_files
  if File.exists?(LOCAL_STATUS)
    File.delete(LOCAL_STATUS)
  end
  if File.exists?(LOCAL_DATA)
    File.delete(LOCAL_DATA)
  end
end
