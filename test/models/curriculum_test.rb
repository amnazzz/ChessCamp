require 'test_helper'

class CurriculumTest < ActiveSupport::TestCase
      # Relationships
    should have_many(:camps)
    
    # Validations
    should validate_presence_of(:name), uniqueness: { case_sensitive: false }
    
    should allow_value(1000).for(:min_rating)
    should allow_value(100).for(:min_rating)
    should allow_value(2872).for(:min_rating)
    should allow_value(0).for(:min_rating)

    should_not allow_value(nil).for(:min_rating)
    should_not allow_value(3001).for(:min_rating)
    should_not allow_value(50).for(:min_rating)
    should_not allow_value(-1).for(:min_rating)
    should_not allow_value(500.50).for(:min_rating)
    should_not allow_value("bad").for(:min_rating)

    should allow_value(1000).for(:max_rating)
    should allow_value(100).for(:max_rating)
    should allow_value(2872).for(:max_rating)

    should_not allow_value(nil).for(:max_rating)
    should_not allow_value(3001).for(:max_rating)
    should_not allow_value(50).for(:max_rating)
    should_not allow_value(-1).for(:max_rating)
    should_not allow_value(500.50).for(:max_rating)
    should_not allow_value("bad").for(:max_rating)
  
    should "shows that max rating is greater than min rating" do
        bad = FactoryBot.build(:curriculum, name: "Bad curriculum", min_rating: 500, max_rating: 800)
        very_bad = FactoryBot.build(:curriculum, name: "Very bad curriculum", min_rating: 300, max_rating: 450)
        deny bad.valid?
        deny very_bad.valid?
    end
    
    context "Within context" do
     setup do
       create_curriculums
     end

     teardown do
       delete_curriculums
     end
    
     should "have a scope to put curriculums in alphabetical order" do
      assert_equal ["Endgame Principles", "Mastering Chess Tactics", "Smith-Morra Gambit"], Curriculum.alphabetical.all.map(&:name), "#{Curriculum.class}"
     end

     should "have a scope to select active camps" do
      assert_equal ["Endgame Principles", "Mastering Chess Tactics"], Curriculum.active.all.map(&:name).sort, "#{Curriculum.methods}"
     end

     should "have a scope to select inactive camps" do
      assert_equal ["Smith-Morra Gambit"], Curriculum.inactive.all.map(&:name).sort
     end

     should "shows that there is a working for_rating scope" do
      assert_equal ["Mastering Chess Tactics","Smith-Morra Gambit"], Curriculum.for_rating(600).all.map(&:name).sort
     end
    end
end
