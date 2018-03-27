json.page_info do
  json.partial! 'v1/page_info.json.jbuilder', data: @comments, timestamp: @timestamp, limit: @limit
end
json.comments do
  json.array! @comments, partial: 'v1/comments/comment.json.jbuilder', as: :comment
end