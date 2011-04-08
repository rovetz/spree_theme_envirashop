require 'spree_core'
require 'spree_theme_envirashop_hooks'

module SpreeThemeEnvirashop
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      # make your helper avaliable in all views
      Spree::BaseController.class_eval do
        helper :products
      end

      ContentController.class_eval do
        def home
          @featured_product = Product.active.first
          @products = Product.active.all :limit => 10, :offset => 1
          render "home", :layout => false
        end
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
