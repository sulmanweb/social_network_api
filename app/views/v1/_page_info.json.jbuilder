json.timestamp timestamp
json.limit limit
json.page_size data.size

if data.size == 0
  json.more_available false
else
  json.more_available !data.last_page?
end

# totalRecords
json.total_records data.total_count

# page
json.page data.current_page

# total_pages
json.total_pages data.total_pages