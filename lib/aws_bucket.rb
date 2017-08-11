# require 'aws-sdk'  # use for inline testing

# Aws.use_bundled_cert!  # user for inline testing - resolves "certificate verify failed"

# load "./local_env.rb" if File.exists?("./local_env.rb")  # use for inline testing


# Method to connect to AWS S3 bucket
def connect_to_s3()

  Aws::S3::Client.new(
    access_key_id: ENV['S3_KEY'],
    secret_access_key: ENV['S3_SECRET'],
    region: ENV['AWS_REGION'],
    force_path_style: ENV['PATH_STYLE']
  )
  
end


# Method to list AWS S3 buckets
def list_s3_buckets()

  s3 = connect_to_s3()
  response = s3.list_buckets

  response.buckets.each do |bucket|
    puts "#{bucket.creation_date} #{bucket.name}"
  end

end


# Method to save uploaded file to temp directory
def save_tmp_file(upload_hash)

  tmp_dir = "./public/tmp"
  image = File.binread(upload_hash["image"][:tempfile])  # open image file

  f = File.new "#{tmp_dir}/#{upload_hash["image"][:filename]}", "wb"
  f.write(image)
  f.close if f

  puts "save_tmp_file() - uploaded file saved to temp directory!"
  url = save_file_to_s3_bucket("prototype-jv", "#{upload_hash["image"][:filename]}")

end



# Method to clean up temp file after uploading to AWS S3 bucket
def cleanup_tmp_file(file)

  image_path = "./public/tmp/#{file}"

  if File.exist?(image_path)
    File.delete(image_path)
    puts "cleanup_tmp_file() - temp file deleted!"
  else
    puts "cleanup_tmp_file() - file does not exist!"
  end

end


# Method to upload file to AWS S3 bucket if not already present
def save_file_to_s3_bucket(bucket, file)

  image_path = "./public/tmp/#{file}"
  connect_to_s3()
  s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
  obj = s3.bucket(bucket).object(file)

  if obj.exists?
    cleanup_tmp_file(file)
    puts "File #{file} already exists in the bucket."
    url = generate_url(bucket, file)
  else
    obj.upload_file(image_path)
    cleanup_tmp_file(file)
    puts "Uploaded file (#{file}) to bucket (#{bucket})."
    url = generate_url(bucket, file)
  end

end


# Method to list files in AWS S3 bucket
def list_s3_bucket_files(bucket)

  s3 = connect_to_s3()
  resp = s3.list_objects_v2(bucket: bucket)
  counter = 1

  resp.contents.each do |obj|
    puts "#{bucket} bucket file #{counter}: #{obj.key}"
    counter += 1
  end

end


# Method to generate secure URL for target file (expires after 15 minutes)
def generate_url(bucket, file)

  connect_to_s3()
  signer = Aws::S3::Presigner.new
  url = signer.presigned_url(:get_object, bucket: bucket, key: file)

end