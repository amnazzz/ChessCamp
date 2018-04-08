class Instructor < ApplicationRecord
        # Relationships
    has_many :camp_instructors
    has_many :camps, through: :camp_instructors
    
    # Validations
    validates_presence_of :first_name
    validates_presence_of :last_name
    validates :email, presence:true, uniqueness: {case_sensitive: false}, format: { with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, message: "is not a valid format" }
    validates :phone, format: { with: /\A\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}\z/, message: "should be 10 digits (area code needed) and delimited with dashes only", allow_blank: true }

    
    # Scopes
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :alphabetical, -> { order('last_name, first_name') }
    scope :needs_bio, -> { where('bio IS NULL') }
 
    # Methods
    def self.for_camp(camp)
        camp.instructors
    end
    
    before_save :reformat_phone 
    
    def name
        last_name + ", " + first_name
    end
    
    def proper_name
        first_name + " " + last_name
    end
    
    private
    def reformat_phone
        phone = self.phone.to_s 
        phone.gsub!(/[^0-9]/,"")
        self.phone = phone    
    end
end
