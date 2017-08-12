module Permission
  def self.permission_for(user, session_id)
    if user.nil?
      GuestPermission.new(session_id)
    elsif user.admin?
      AdminPermission.new(user)
    else
      UserPermission.new(user)
    end
  end
end
