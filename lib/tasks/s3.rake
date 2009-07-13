require 'aws/s3'

namespace :s3 do
  @s3 = YAML::load(ERB.new(IO.read("#{RAILS_ROOT}/config/s3.yml")).result)[RAILS_ENV]
  AWS::S3::Base.establish_connection!(
    :access_key_id => @s3['access_key'],
    :secret_access_key => @s3['secret_key']
  )
  
  namespace :db do
    desc "Backup the datbase to s3"
    task :backup => [:environment] do |t|
      database = YAML.load_file("#{RAILS_ROOT}/config/database.yml")[RAILS_ENV]
      filename = "#{Time.now.strftime('%Y%m%d_%H%M%S')}_#{RAILS_ENV}.sql.gz"
      `mysqldump -u#{database['username']} -p#{database['password']} -h #{database['host']} #{database['database']} | gzip > #{RAILS_ROOT}/tmp/#{filename}`
      send_file("#{RAILS_ROOT}/tmp/#{filename}", filename)
    end
    task :restore => [:environment] do
    end
    task :get => [:environment] do
    end
  end
  
  def send_file(from, to)
    AWS::S3::S3Object.store(to, File.open(from), @s3['bucket'])
  end
end