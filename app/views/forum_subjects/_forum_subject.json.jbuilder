json.extract! forum_subject, :id, :name, :text, :customer_id, :forum_category_id, :counter_cache, :created_at, :updated_at
json.url forum_subject_url(forum_subject, format: :json)
