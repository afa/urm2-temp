require 'sass/plugin'
Urm::Application.configure do
    # Sass
    config.sass.remove_template_location(File.join(Rails.root, "public", "stylesheets", "sass"))
    config.sass.add_template_location(File.join(Rails.root, "assets", "stylesheets", "sass"), File.join(Rails.root, "assets", "stylesheets"))
end

