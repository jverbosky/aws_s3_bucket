require 'aws-sdk'
require 'sinatra'

require_relative './lib/aws_bucket.rb'

Aws.use_bundled_cert!  # resolves "certificate verify failed"

load "./lib/local_env.rb" if File.exists?("./lib/local_env.rb")


# Route to prompt user to upload image file
get "/" do

  erb :upload

end


# Route to upload image to AWS S3 bucket and read back from bucket
post "/readback" do

  upload_hash = params[:upload]

  image = save_tmp_file(upload_hash)
  
  erb :bucket, locals: {image: image}

end

