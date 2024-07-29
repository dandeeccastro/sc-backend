module Permissions
  def set_permissions(user_id:nil)
    @permissions = {
      admin: @current_user && @current_user.admin?,
      staff_leader: @current_user && @current_user.staff_leader? && @current_user.runs_event?(@event),
      staff_leader_perm: @current_user && @current_user.staff_leader?,
      staff: @current_user && @current_user.staff? && @current_user.runs_event?(@event),
      owns_resource: @current_user && @current_user.id == user_id,
      attendee: @current_user && @current_user.attendee?,
    }
  end

  def check_permissions(permissions)
    allowed = false
    permissions.each { |permission| allowed |= @permissions[permission] }
    render json: { message: 'Não tem permissão para executar ação!' }, status: :unauthorized unless allowed
  end
end
