require 'app'
require 'test/unit'
require 'rack/test'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_index
    get '/'
    assert_equal 200, last_response.status
    assert_match 'Let me "goggle" that for you', last_response.body
  end

  def test_has_empty_form
    get '/'
    assert_match /<input type="text" name="i" id="i" size="55" ?>/, last_response.body
    assert_match /<input type="text" name="c" id="c" size="55" ?>/, last_response.body
    assert_match /<input type="submit" value="Google Search" name="btnG" id="btnG" ?>/, last_response.body
  end

  def test_has_filled_form_with_params
    get '/', :i => "foo", :c => "bar"
    assert_match /<input type="text" name="q" id="q" size="55" value="bar" ?>/, last_response.body
    assert_match /<input type="submit" value="Google Search" name="btnG" id="btnG" class="clickme" ?>/, last_response.body
  end

  def test_use_lucky_button_when_requested
    get '/', :i => "foo", :c => "bar", :l => "true"
    assert_no_match /<input type="submit" value="Google Search" name="btnG" id="btnG" class="clickme" ?>/, last_response.body
    assert_match /<input type="submit" value="I'm Feeling Lucky" name="btnI" id="btnI" class="clickme" ?>/, last_response.body
  end
end
