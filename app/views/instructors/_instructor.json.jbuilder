json.extract! instructor, :id, :first_name, :last_name, :bio, :email, :phone, :active, :created_at, :updated_at
json.url instructor_url(instructor, format: :json)
