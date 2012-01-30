require 'sass/plugin'
Sass::Plugin.remove_template_location(File.join(Rails.root, "public", "stylesheets", "sass"))
Sass::Plugin.add_template_location(File.join(Rails.root, "assets", "stylesheets", "sass"), File.join(Rails.root, "assets", "stylesheets"))
#Urm::Application.configure do
#    # Sass
#    config.sass.remove_template_location(File.join(Rails.root, "public", "stylesheets", "sass"))
#    config.sass.add_template_location(File.join(Rails.root, "assets", "stylesheets", "sass"), File.join(Rails.root, "assets", "stylesheets"))
#end

