# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'stylesheets')
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'builds')
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
# Rails.application.config.assets.precompile += %w(
#   tailwind.css
#   spree/frontend/tailwind.css
#   spree/frontend/compiled-styles.css
#   ckeditor/config.js
#   .svg
# )

Rails.application.config.assets.precompile += %w(
  tailwind.css
  spree/frontend/tailwind.css
  spree/frontend/compiled-styles.css
  ckeditor/config.js
  images/*.png
  *.ttf
  *.eot
  *.woff
  *.svg
  *.gif
  *.png
  *.jpg
  *.jpeg
)

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
#Rails.application.config.assets.precompile += %w[ckeditor/config.js]
