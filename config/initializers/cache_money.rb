#http://github.com/nkallen/cache-money/tree/master
=begin
config = YAML.load(IO.read(File.join(RAILS_ROOT, "config", "memcached.yml")))[RAILS_ENV]
$memcache = MemCache.new(config)
$memcache.servers = config['servers']

$local = Cash::Local.new($memcache)
$lock = Cash::Lock.new($memcache)
$cache = Cash::Transactional.new($local, $lock)

class ActiveRecord::Base
  is_cached :repository => $cache
end

ActionController::Base.cache_store = $memcache
=end