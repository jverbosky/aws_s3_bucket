## AWS S3 Bucket Prototype ##

This Sinatra web app works as follows:

1. Prompts the user for an image file to upload (via a form)
2. Writes the image to a local temp directory (./public/tmp)
3. Uploads the image to the specified AWS S3 bucket
4. Deletes the image from the local temp directory
5. Generates a secure URL to the uploaded image in the S3 bucket
6. Renders the image from the S3 bucket using the secure URL

----------

### Prerequisites ###

In order to use this app, you should do the following:

1. Run the following command to install the aws-sdk gem:

	`gem install aws-sdk`

2. Create an AWS S3 bucket.
3. Create an IAM user with access limited to S3.
4. Document the access key ID and secret access key for the user.
5. Create a *local\_env.rb* file with the access key ID and secret access key  
	- see */lib/local\_env.rb.sample* for example

**Resources**

- [Creating an S3 Bucket](http://docs.aws.amazon.com/AmazonS3/latest/gsg/CreatingABucket.html)
- [IAM Users](http://docs.aws.amazon.com/IAM/latest/UserGuide/id.html)
- [Access Keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys)
 
----------

### Running the App Locally ###

To run the app locally:

1. Make sure that [Ruby](https://www.ruby-lang.org/en/documentation/installation/) is installed.
2. Make sure that the [Sinatra](https://github.com/sinatra/sinatra) gem is installed.  *Note that installing the Sinatra gem will install other gems necessary to run the app locally, such as rack.*
3. Navigate to the directory which contains **app.rb** in a terminal (command prompt) session.
4. Run the following command to launch the Sinatra web server:

	`ruby app.rb`

To open the app locally once it is running via *ruby*, use the following URL:

[http://localhost:4567](http://localhost:4567/)

----------