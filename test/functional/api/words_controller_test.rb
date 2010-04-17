require 'test_helper'

class Api::WordsControllerTest < ActionController::TestCase

  test "should create a word when the required valid json is provided" do
    assert_difference('Word.count') do
      json = {"stem" => "te", "pos" => "Adj", "count" => 12,
        "literal" => "testeado", "lemma" => "test",
        "representative" => false, "date" => "2009.10.19"}.to_json

      @request.env['RAW_POST_DATA'] = json
      post :create, {}, { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
      @request.env.delete('RAW_POST_DATA')

      assert_response :created
      assert Word.count == 1
    end
  end

  test "should update the count if the same kind of word is sent again" do
    assert_difference('Word.count') do
      json = {"stem" => "te", "pos" => "Adj", "count" => 12,
        "literal" => "testeado", "lemma" => "test",
        "representative" => false, "date" => "2009.10.19"}.to_json

      @request.env['RAW_POST_DATA'] = json
      post :create, {}, { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
      @request.env.delete('RAW_POST_DATA')

      assert_response :created
      assert Word.count == 1

      json = {"stem" => "te", "pos" => "Adj", "count" => 1,
        "literal" => "testeado", "lemma" => "test",
        "representative" => false, "date" => "2009.10.19"}.to_json

      @request.env['RAW_POST_DATA'] = json
      post :create, {}, { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
      @request.env.delete('RAW_POST_DATA')

      assert_response :created
      assert Word.count == 1

      assert Word.first.count == 13
    end
  end


  test "should destroy all the words if no param" do
    Word.create!("stem" => "te", "pos" => "Adj", "count" => 12,
                 "literal" => "testeado", "lemma" => "test",
                 "representative" => false, "date" => "2009.10.19")

    assert Word.count == 1

    delete :destroy, {}

    assert_response :success
    assert Word.count == 0
  end

end
