$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'balbo'

class Passenger
  def server
    "example.com"
  end

  def deploy_to
    "/var/www/example.com"
  end

  def stage
    "production"
  end

  def timestamp
    Time.now.strftime('%Y%m%d%H%M%S')
  end
end

if $0 == __FILE__
  puts balbo('passenger', Passenger.new, File.dirname(__FILE__), 'conf')
end

__END__
<VirtualHost *>
  ServerName example.com
  DocumentRoot /var/www/example.com
  RailsEnv production
</VirtualHost>
