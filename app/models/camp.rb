class Camp < ApplicationRecord
            # Relationships
    has_many :instructors, through: :camp_instructors
    belongs_to :location
    belongs_to :curriculum
    has_many :camp_instructors
    
    # Validations
    validates_presence_of :curriculum_id
    validates_presence_of :location_id
    validates_presence_of :start_date
    validates_presence_of :time_slot
    validates_numericality_of :cost, greater_than_or_equal_to: 0
    validates_date :start_date, :on_or_after => lambda { Date.today }, :on_or_after_message => "cannot be in the past", on:  :create
    validates_date :end_date, :on_or_after => :start_date
    validates_inclusion_of :time_slot, in: %w[am pm], message: "is not an accepted time slot"
    validates_numericality_of :max_students, only_integer: true, greater_than: 0, allow_blank: true
    
    validate :active_curriculum
    validate :active_location
    validate :no_dupelicated_camps, on: :create
    validate :max_smaller_capacity
    
    # Scopes
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :alphabetical, -> { joins(:curriculum).order('curriculums.name, camps.curriculum_id') }
    scope :chronological, -> { order 'start_date ASC', 'end_date ASC' }
    scope :morning, -> {where(time_slot: 'morning')}
    scope :afternoon, -> {where(time_slot: 'afternoon')}
    scope :upcoming, -> {where('start_date >= ?', Date.today)}
    scope :past, -> {where('end_date <= ?', Date.today)}
    scope :for_curriculum, ->(curriculum_id) {where('curriculum_id = ?', curriculum_id)}
    
    # Methods
    def name
        self.curriculum.name
    end
    
    def exists?
        Camp.where(time_slot: self.time_slot, start_date: self.start_date, location_id: self.location_id).size == 1
    end
    
    before_update :will_remove
    
    def active_curriculum
        return if self.curriculum.nil?
        errors.add(:curriculum, "is not currently active") unless self.curriculum.active
    end

    def active_location
        return if self.location.nil?
        errors.add(:location, "is not currently active") unless self.location.active
    end
    
    def no_dupelicated_camps
        return true if self.time_slot.nil? || self.start_date.nil? || self.location_id.nil?
        if self.already_exists?
            errors.add(:time_slot, "already exists for start date, time slot and location")
        end
    end
    
    def max_smaller_capacity
        return true if self.max_students.nil? || self.location_id.nil?
        if self.max_students > self.location.max_capacity
            errors.add(:max_students, "is greater than the location capacity")
        end
    end
    
    def will_remove
      if !self.active
        self.camp_instructors.each{|ci| ci.destroy}
      end
    end
end
