json.extract! curriculum, :id, :name, :min_rating, :max_rating, :description, :active, :created_at, :updated_at
json.url curriculum_url(curriculum, format: :json)
