module Permission
  class AdminPermission < BasePermission
    def initialize(user)
      allow_all
    end
  end
end
