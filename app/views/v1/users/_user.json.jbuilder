json.extract! user, :id, :username, :name, :created_at
if @current_user && @current_user != user
  json.requested @current_user.friend_requested? user
  json.friend @current_user.friend? user
end