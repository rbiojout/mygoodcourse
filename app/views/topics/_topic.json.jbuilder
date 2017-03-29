json.extract! topic, :id, :name, :position, :slug, :country_id, :created_at, :updated_at
json.description sanitize(topic.description, scrubber: VideoScrubber.new)
json.url topic_url(topic, format: :json)
