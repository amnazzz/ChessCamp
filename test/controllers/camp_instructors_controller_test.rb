require 'test_helper'

class CampInstructorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @camp_instructor = camp_instructors(:one)
  end

  test "should get index" do
    get camp_instructors_url
    assert_response :success
  end

  test "should get new" do
    get new_camp_instructor_url
    assert_response :success
  end

  test "should create camp_instructor" do
    assert_difference('CampInstructor.count') do
      post camp_instructors_url, params: { camp_instructor: { camp_id: @camp_instructor.camp_id, instructor_id: @camp_instructor.instructor_id } }
    end

    assert_redirected_to camp_instructor_url(CampInstructor.last)
  end

  test "should show camp_instructor" do
    get camp_instructor_url(@camp_instructor)
    assert_response :success
  end

  test "should get edit" do
    get edit_camp_instructor_url(@camp_instructor)
    assert_response :success
  end

  test "should update camp_instructor" do
    patch camp_instructor_url(@camp_instructor), params: { camp_instructor: { camp_id: @camp_instructor.camp_id, instructor_id: @camp_instructor.instructor_id } }
    assert_redirected_to camp_instructor_url(@camp_instructor)
  end

  test "should destroy camp_instructor" do
    assert_difference('CampInstructor.count', -1) do
      delete camp_instructor_url(@camp_instructor)
    end

    assert_redirected_to camp_instructors_url
  end
end
