require 'sinatra'

require_relative '../../container'
require_relative './carts'
require_relative './items'


set :bind, '0.0.0.0'
set :port, 4567

Container.setup
