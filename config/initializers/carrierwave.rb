CarrierWave.configure do |config|
  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  else
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['S3_KEY'],
      :aws_secret_access_key  => ENV['S3_SECRET'],
      :region                 => ENV['S3_REGION']
    }
  end
  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.fog_public     = true
  config.fog_directory  = ENV['S3_BUCKET_NAME']
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
end