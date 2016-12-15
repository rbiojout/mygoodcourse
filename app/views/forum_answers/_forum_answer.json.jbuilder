json.extract! forum_answer, :id, :text, :customer_id, :forum_subject_id, :created_at, :updated_at
json.url forum_answer_url(forum_answer, format: :json)
