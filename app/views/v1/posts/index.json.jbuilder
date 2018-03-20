json.page_info do
  json.partial! 'v1/page_info.json.jbuilder', data: @posts, timestamp: @timestamp, limit: @limit
end
json.posts do
  json.array! @posts, partial: 'v1/posts/post.json.jbuilder', as: :post
end