def set_current_user(user=nil)
  user ||= Fabricate(:user)
  session[:user_id] = user.id
end

def current_user
  User.find_by(id: session[:user_id])
end