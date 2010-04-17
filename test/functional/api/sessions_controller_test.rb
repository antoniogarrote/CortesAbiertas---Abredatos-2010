require 'test_helper'

class Api::SessionsControllerTest < ActionController::TestCase

  test "should create a new session" do
    assert_difference('Session.count') do


      json = { "words_json" => [{"count"=>2, "literal"=>"levanta", "lemma"=>"levantar",
                                 "stem"=>"levant", "pos"=>"VLfin"},
                                {"count"=>2, "literal"=>"levanta", "lemma"=>"levantar",
                                 "stem"=>"levant", "pos"=>"VLfin"}],
               "identifier" => "something",
               "date" => "2009.10.19",
               "content" => "This is a text",
               "day_order" => "The day order" }.to_json

      @request.env['RAW_POST_DATA'] = json
      post :create, {}, { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
      @request.env.delete('RAW_POST_DATA')

      assert_response :created
    end
  end

  test "should create a new session with the id name instead of the identifier" do
    assert_difference('Session.count') do

      json = { "words_json" => [{"count"=>2, "literal"=>"levanta", "lemma"=>"levantar",
                                 "stem"=>"levant", "pos"=>"VLfin"},
                                {"count"=>2, "literal"=>"levanta", "lemma"=>"levantar",
                                 "stem"=>"levant", "pos"=>"VLfin"}],
               "date" => "2009.10.19",
               "id" => "test algo",
               "content" => "This is a text",
               "day_order" => "The day order" }.to_json

      @request.env['RAW_POST_DATA'] = json
      post :create, {}, { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
      @request.env.delete('RAW_POST_DATA')

      assert_response :created
    end
  end

  test "should return all the sessions" do

    get :show

    sessions = ActiveSupport::JSON.decode(@response.body)
    assert sessions.length == 1
  end

  test "should return sessions according to the id" do
    get :show, { :id => 1}

    session = ActiveSupport::JSON.decode(@response.body)
    assert session["identifier"] == "op 3123123"
  end

  test "should return sessions according to the provided identifier" do

    get :show, { :identifier => "op 3123123"}

    session = ActiveSupport::JSON.decode(@response.body)
    assert session["identifier"] == "op 3123123"
  end


  test "should destroy all the procurators" do

    delete :destroy, { }

    assert Session.count == 0
  end

end
