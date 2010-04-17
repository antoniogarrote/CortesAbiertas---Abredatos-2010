require 'test_helper'

class Api::ParliamentMembersControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "should create a new orator" do
    assert_difference('ParliamentMember.count') do

      json = { "name" => "Mr. Eko", "words_json" => [{"count"=>2, "literal"=>"levanta", "lemma"=>"levantar",
                                                       "stem"=>"levant", "pos"=>"VLfin"},
                                                     {"count"=>2, "literal"=>"levanta", "lemma"=>"levantar",
                                                       "stem"=>"levant", "pos"=>"VLfin"}]}.to_json

      @request.env['RAW_POST_DATA'] = json
      post :create, {}, { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
      @request.env.delete('RAW_POST_DATA')

      assert_response :created
    end
  end

  test "should return all the procurators" do

    get :show

    orators = ActiveSupport::JSON.decode(@response.body)
    assert orators.count == 2
  end

  test "should return one procurators" do

    get :show, { :name => "John Locke"}

    orator = ActiveSupport::JSON.decode(@response.body)

    assert orator["name"] == "John Locke"
  end

  test "should destroy all the procurators" do

    delete :destroy, { }

    assert ParliamentMember.count == 0
  end
end
