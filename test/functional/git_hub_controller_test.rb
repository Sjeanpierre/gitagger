require 'test_helper'

class GitHubControllerTest < ActionController::TestCase
  test "should get repo" do
    get :repo
    assert_response :success
  end

  test "should get branch" do
    get :branch
    assert_response :success
  end

  test "should get repo" do
    get :repo
    assert_response :success
  end

  test "should get tag" do
    get :tag
    assert_response :success
  end

end
