def current_user
  User.find_by(id: session[:user_id])
end

def set_current_user(user=nil)
  user ||= Fabricate(:user)
  session[:user_id] = user.id
end

def sign_in(user=nil)
  user ||= Fabricate(:user)
  visit sign_in_path
  fill_in 'Email Address', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end
