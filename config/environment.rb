# Load the Rails application.
require File.expand_path('../application', __FILE__)

# ActiveLDAP assumes yaml is already loaded (probs by sprockets)
# Bad assumptions make this gross, but less gross than monkey patching
# the gem.
require 'yaml'

# Initialize the Rails application.
Rails.application.initialize!
