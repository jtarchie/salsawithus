namespace :facebooker do
  desc "Register the feed bundles"
  task :register_feed_bundles => [:environment] do |t|
    #publishers = Object.constants.select{|c| c=~/Publisher$/}.collect{|c|c.constantize}
    publishers = Dir["#{RAILS_ROOT}/app/models/*.rb"].collect{|f|File.basename(f,".rb")}.select{|f|f=~/_publisher/}.collect{|f|f.classify.constantize}
    publishers.each do |publisher|
      puts "Reviewing #{publisher.name}"
      publisher.register_all_templates
    end
  end
end