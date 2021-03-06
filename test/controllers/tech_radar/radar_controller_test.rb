require 'test_helper'

module TechRadar
  class RadarControllerTest < ActionController::TestCase
    setup do
      @routes = Engine.routes
    end

    test "parent app can override messages" do
      get :index
      assert_response :success
      assert response.body =~ /FOOBAR/, "expected #{response.body} to include FOOBAR"
    end

    test "the radar summary screen" do
      get :summary
      assert_response :success
    end

  end
end
