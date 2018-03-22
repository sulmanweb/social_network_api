json.page_info do
  json.partial! 'v1/page_info.json.jbuilder', data: @users, timestamp: @timestamp, limit: @limit
end
json.users do
  json.array! @users, partial: 'v1/users/user.json.jbuilder', as: :user
end