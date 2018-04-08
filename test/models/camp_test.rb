require 'test_helper'

class CampTest < ActiveSupport::TestCase
    # Relationships
     should have_many(:instructors).through(:camp_instructors)
     should belong_to(:location)
     should belong_to(:curriculum)
     should have_many(:camp_instructors)
    
    # Validations
    should validate_presence_of(:curriculum_id)
    should validate_presence_of(:location_id)
    should validate_presence_of(:start_date)
    should validate_presence_of(:time_slot)
    
    #start date
    should allow_value(Date.today).for(:start_date)
    should allow_value(1.day.from_now.to_date).for(:start_date)
    should_not allow_value(1.day.ago.to_date).for(:start_date)
    should_not allow_value("bad").for(:start_date)
    should_not allow_value(2).for(:start_date)
    should_not allow_value(3.14).for(:start_date)
    
    #end date
    should_not allow_value("bad").for(:end_date)
    should_not allow_value(2).for(:end_date)
    should_not allow_value(3.14).for(:end_date)
    
    #cost
    should validate_numericality_of(:cost)
    should allow_value(0).for(:cost)
    should allow_value(125).for(:cost)
    should allow_value(125.00).for(:cost)
    should_not allow_value(-29).for(:cost)
    should_not allow_value("bad").for(:cost)
    
    #time slot
    should allow_value('am').for(:time_slot)
    should allow_value('pm').for(:time_slot)
    should_not allow_value("bad").for(:time_slot)
    should_not allow_value("12:00").for(:time_slot)
    should_not allow_value(1200).for(:time_slot)
    
    #max students
    should validate_numericality_of(:max_students)
    should allow_value(nil).for(:max_students)
    should allow_value(1).for(:max_students)
    should allow_value(12).for(:max_students)
    should_not allow_value("bad").for(:max_students)
    should_not allow_value(0).for(:max_students)
    should_not allow_value(-5).for(:max_students)
    should_not allow_value(3.14).for(:max_students)
    
    
    context "Within context" do
      setup do
        create_curriculums
        create_locations
        create_camps
      end
  
      teardown do
        delete_curriculums
        delete_locations
        delete_camps
      end
      
      should "make sure there is a camp name" do
        assert_equal "Mastering Tactics", @camp.name
      end
      
      should "make sure the curriculum is active" do
        bad_camp = FactoryBot.build(:camp, curriculum: @smithmorra, location: @cmu, start_date: Date.new(2014,8,1), end_date: Date.new(2014,8,5))
        deny bad_camp.valid?
        gambit = FactoryBot.build(:curriculum, name: "King's Gambit")
        gambit_camp = FactoryBot.build(:camp, curriculum: gambit, location: @cmu, start_date: Date.new(2014,8,1), end_date: Date.new(2014,8,5))
        deny gambit_camp.valid?
      end
      
      should "make sure the location is active" do
        create_inactive_locations
        bad_camp = FactoryBot.build(:camp, curriculum: @tactics, location: @sqhill, start_date: Date.new(2014,8,1), end_date: Date.new(2014,8,5))
        deny bad_camp.valid?
        delete_inactive_locations
        bhill = FactoryBot.build(:location, name: "Blueberry Hill")
        bhill_camp = FactoryBot.build(:camp, curriculum: @tactics, location: bhill, start_date: Date.new(2014,8,1), end_date: Date.new(2014,8,5))
        deny bhill_camp.valid?
      end
      
       should "have a scope to order results alphabetically by curriculum name" do
         assert_equal ["Mastering Tactics","Not Mastering Tactics"], Camp.alphabetical.all.map{|c| c.curriculum.name}
       end
  
       should "have a scope to select active camps" do
         assert_equal ["Mastering Tactics"], Camp.active.all.map{|c| c.curriculum.name}
       end
  
       should "have a scope to select inactive camps" do
         assert_equal ["Not Mastering Tactics"], Camp.inactive.all.map{|c| c.curriculum.name}
       end
      
       should "have a scope to order results chronologically by start_date, end_date" do
         assert_equal ["Mastering Tactics", "Not Mastering Tactics"], Camp.chronological.all.map{|c| "#{c.name}"}
       end
      
       should "have a scope to return all camps in the morning time slot" do
         assert_equal ["Mastering Tactics"], Camp.morning.all.map{|c| c.name}
       end
      
       should "have a scope to return all camps in the afternoon time slot" do
         assert_equal ["Not Mastering Tactics"], Camp.afternoon.all.map{|c| c.name}
       end
      
       should "have name methods that return the name of the curriculum" do
         assert_equal "Mastering Tactics", @camp.name.map{|c| c.curriculum.name}
       end
      
       should "have a scope to return all camps going on today or in the future or in the past" do
         @camp.update_attribute(:start_date, 7.days.ago.to_date)
         @camp.update_attribute(:end_date, 2.days.ago.to_date)
         assert_equal 1, Camp.upcoming.size
         assert_equal 1, Camp.past.size
       end
      
       should "show that its fine to have 2 camps with the same date and time slot but dif location" do
         @test_camp = FactoryBot.build(:camp, curriculum: @curriculum, location: @location, start_date: Date.new(2018,7,23), end_date: Date.new(2018,7,27), time_slot: 'am')
         assert @test_camp.valid?
       end
      
       should "no duplicates in date, time and location allowed" do
         @bad_camp = FactoryBot.build(:camp, curriculum: @curriculum, location: @location, start_date: Date.new(2018,7,23), end_date: Date.new(2018,7,27), time_slot: 'am')
         deny @bad_camp.valid?
       end
      
       should "allow past camps to be edited" do
         @camp.update_attribute(:start_date, 7.days.ago.to_date)
         @camp.update_attribute(:end_date, 2.days.ago.to_date)
         @camp.reload
         @camp.max_students = 7
         @camp.save!
         @camp.reload 
         assert_equal 7, @camp.max_students
       end
      
       should "have a scope to return all camps for specified curriculum" do
         assert_equal ["Mastering Tactics"], Camp.for_curriculum(42).all.map(&:name)
       end
      
      
       should "check all end dates are on or after the start date" do
         @no_camp = FactoryBot.build(:camp, curriculum: @curriculum, location: @location, start_date: 9.days.from_now.to_date, end_date: 5.days.from_now.to_date)
         deny @no_camp.valid?
         @yes_camp = FactoryBot.build(:camp, curriculum: @curriculum, location: @location, start_date: 9.days.from_now.to_date, end_date: 9.days.from_now.to_date)
         assert @yes_camp.valid?
       end
      
       should "max_students should not exceed capacity" do
         @camp.max_students = 100
         deny @camp.valid?
       end
  
      
       should "have will_remove methods that removes instructors any inactive camp" do
         create_instructors
         create_camp_instructors
         deny @camp.camp_instructors.to_a.empty?
         @camp.active = false
         @camp.save
         @camp.reload
         assert @camp.camp_instructors.to_a.empty?
         destroy_camp_instructors
         destroy_instructors
       end
      
       should "not allow you to remove instructors from edited, active camps" do
         create_instructors
         create_camp_instructors
         deny @camp.camp_instructors.to_a.empty?
         total_instructors = @camp.camp_instructors.count
         @camp.max_students -= 1
         @camp.save
         @camp.reload
         assert_equal(@camp.camp_instructors.count, total_instructors)
         destroy_camp_instructors
         destroy_instructors
       end
      
    end
end
