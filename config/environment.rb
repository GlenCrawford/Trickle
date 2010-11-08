# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Trickle::Application.initialize!

ActionView::Base.field_error_proc = Proc.new do
  |input, instance| input
end