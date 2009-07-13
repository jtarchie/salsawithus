namespace :salsawithus do
  namespace :import do
    task :setup do |t|
      unless File.exists?(ENV['filename'] || '')
        puts "Please include filename as a parameter\nusage: rake import:csv filname=test.csv"
        exit()
      end
      @user = User.find(ENV['user_id'] || 1)
    end
    desc "Import a csv with listings"
    task :csv => [:environment, :setup] do |t|
      require 'csv'
      CSV.foreach(ENV['filename']) do |row|
        #name, address, state, city, phone number, URL, comments
        venue = Venue.new(
          :name =>row[0],
          :address => "#{row[1]},#{row[2]},#{row[3]}",
          :phone_number => row[4],
          :url => row[5],
          :user => @user
        )
        venue.geocode_address!
        venue.display = venue.has_coords?
        print "Saving #{venue.name} - "
        if venue.save
          puts "Successful"
        else
          puts "Unsuccessul - #{venue.errors.full_messages.join(', ')}"
        end
      end
    end
  end
end