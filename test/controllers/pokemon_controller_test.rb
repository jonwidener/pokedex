require "test_helper"

class PokemonControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get pokemon_show_url
    assert_response :success
  end
end
