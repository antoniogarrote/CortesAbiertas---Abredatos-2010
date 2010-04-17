require 'test_helper'

class Api::InterventionsControllerTest < ActionController::TestCase

  test "should create a new intervention" do
    assert_difference('Intervention.count') do


      json = { "parliament_member_id" => "1",
               "words_json" => [{"count"=>2, "literal"=>"levanta", "lemma"=>"levantar",
                                 "stem"=>"levant", "pos"=>"VLfin"},
                                {"count"=>2, "literal"=>"levanta", "lemma"=>"levantar",
                                 "stem"=>"levant", "pos"=>"VLfin"}],
               "date" => "2009.10.19",
               "text" => "This is a text"}.to_json

      @request.env['RAW_POST_DATA'] = json
      post :create, {}, { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
      @request.env.delete('RAW_POST_DATA')

      assert_response :created
    end
  end

  test "should create a new intervention with the orator name instead of the id" do
    assert_difference('Intervention.count') do


      json = { "parliament_member" => "John Locke",
               "words_json" => [{"count"=>2, "literal"=>"levanta", "lemma"=>"levantar",
                                 "stem"=>"levant", "pos"=>"VLfin"},
                                {"count"=>2, "literal"=>"levanta", "lemma"=>"levantar",
                                 "stem"=>"levant", "pos"=>"VLfin"}],
               "date" => "2009.10.19",
               "text" => "This is a text"}.to_json

      @request.env['RAW_POST_DATA'] = json
      post :create, {}, { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
      @request.env.delete('RAW_POST_DATA')

      assert_response :created
    end
  end

  test "should return all the interventions" do

    get :show

    interventions = ActiveSupport::JSON.decode(@response.body)
    assert interventions.length == 1
  end

  test "should return interventions according to the id" do

    get :show, { :parliament_member_id => 1}

    interventions = ActiveSupport::JSON.decode(@response.body)
    assert interventions.first["parliament_member"]["name"] == "John Locke"
  end

  test "should return interventions according to the provided name" do

    get :show, { :parliament_member => "John Locke"}

    interventions = ActiveSupport::JSON.decode(@response.body)
    assert interventions.first["parliament_member"]["name"] == "John Locke"
  end


  test "should destroy all the procurators" do

    delete :destroy, { }

    assert Intervention.count == 0
  end

end
