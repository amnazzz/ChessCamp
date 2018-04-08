class Curriculum < ApplicationRecord
            # Relationships
    has_many :camps
    
    # Validations
    validates_presence_of :name, uniqueness: { case_sensitive: false }
    array = [0] + (100..3000).to_a
    validates :min_rating, numericality: { only_integer: true }, inclusion: {in: array}
    validates :max_rating, numericality: { only_integer: true }, inclusion: {in: array}
    validate :max_more_than_min
    
    # Scopes
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :alphabetical, -> { order('name') }
    scope :for_rating, ->(rating) { where('min_rating <= ? and max_rating >= ?', rating, rating)}
    
    # Methods
    
  private
  def max_more_than_min
    return true if self.max_rating.nil? || self.min_rating.nil?
    unless self.max_rating > self.min_rating
      errors.add(:max_rating, "must be greater than the minimum rating")
    end
  end
end
