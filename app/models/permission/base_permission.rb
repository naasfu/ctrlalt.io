module Permission
  class BasePermission
    # Check if supplied action is allowed.
    def allow?(controller, action, resource = nil)
      allowed = @allow_all || @allowed_actions[[controller.to_s, action.to_s]]
      allowed && (allowed == true || resource && allowed.call(resource))
    end

    # Allow access to all actions.
    def allow_all
      @allow_all = true
    end

    # Allow access to supplied action.
    def allow_action(controllers, actions, &block)
      @allowed_actions ||= {}
      Array(controllers).each do |controller|
        Array(actions).each do |action|
          @allowed_actions[[controller.to_s, action.to_s]] = block || true
        end
      end
    end
  end
end
