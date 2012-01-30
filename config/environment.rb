# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Urm::Application.initialize!

Urm::Application.configure do
    # Sass
    config.sass.template_location = {"assets/stylesheets/sass" => "assets/stylesheets"}
end
