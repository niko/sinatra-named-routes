require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sinatra/base'
require 'rack/test'
require 'sinatra_named_routes'

class SinatraNamedRoutesTestApp < Sinatra::Base
  register Sinatra::NamedRoutes
end
