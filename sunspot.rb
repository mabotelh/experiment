require "net/http"
require 'sunspot/solr/java'
require 'sunspot/solr/installer'
 
class CukeSunspot
  def initialize
    @server = Sunspot::Rails::Server.new
  end
 
  def start
    unless started?
      @started = Time.now
      @server.start
      up
    end
  end
  
  def started?
    begin
      request = Net::HTTP.get_response(URI.parse(uri))
      true
    rescue Errno::ECONNREFUSED
      false
    end
  end
 
  private
  
  def port
    @server.port
  end
 
  def uri
    "http://0.0.0.0:#{port}/solr/"
  end
 
  def up
    print "\nSunspot server is starting"    
    while starting?
      sleep(1)
      print "."
    end
    print "\n"
 
    puts "Sunspot server took #{'%.2f' % (Time.now - @started)} sec. to get up and running. Let's cuke!"
  end
 
  def starting?
    !started?
  end 
end
 
 # Commented out for now because we are not mocking solr just yet.
# Before("~@search") do
#   # Set the sunspot session to the mock, but keep a reference to the original session
#   $original_sunspot_session = Sunspot.session
#   Sunspot.session = Sunspot::Rails::StubSessionProxy.new($original_sunspot_session)
# end
 
# After("~@search") do
#   # Set the sunspot session back to the actual session, not the mock
#   Sunspot.session = $original_sunspot_session  
# end
 
# Before("@search") do
#   # start solr
#   CukeSunspot.new.start
  
#   # Clear all indexes from indexed models:
#   Venue.remove_all_from_index!
# end

CukeSunspot.new.start
 
# make sure solr is stopped on exit
# at_exit { Sunspot::Rails::Server.new.stop rescue nil }