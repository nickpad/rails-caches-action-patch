# Only apply this patch if Rails version is 2.1.0:
if Rails.version == "2.1.0"

  module ::ActionController::Caching::Actions::ClassMethods
    # Declares that +actions+ should be cached.
    # See ActionController::Caching::Actions for details.
    def caches_action(*actions)
      return unless cache_configured?
      options = actions.extract_options!
      filter_options = { :only => actions, :if => options.delete(:if), :unless => options.delete(:unless) }

      cache_filter = ::ActionController::Caching::Actions::ActionCacheFilter.new(:layout => options.delete(:layout), :cache_path => options.delete(:cache_path), :store_options => options)
      around_filter(cache_filter, filter_options)
    end
  end

  module ::ActionController::Caching::Actions
    class ActionCacheFilter
      def before(controller)
        cache_path = ActionCachePath.new(controller, path_options_for(controller, @options.slice(:cache_path)))
        if cache = controller.read_fragment(cache_path.path, @options[:store_options])
          controller.rendered_action_cache = true
          set_content_type!(controller, cache_path.extension)
          options = { :text => cache }
          controller.send!(:render, options)
          false
        else
          controller.action_cache_path = cache_path
        end
      end

      def after(controller)
        return if controller.rendered_action_cache || !caching_allowed(controller)
        controller.write_fragment(controller.action_cache_path.path, controller.response.body, @options[:store_options])
      end
    end
  end

end
