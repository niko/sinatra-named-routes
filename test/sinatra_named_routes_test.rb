require 'test_helper'

class SinatraNamedRoutesTest < Test::Unit::TestCase
  
  context "a Sinatra app with Sinatra::NamedRoutes registered" do
    setup do
      @app = SinatraNamedRoutesTestApp.new
    end
    
    should "return the index path" do
      name_route :index, '/'
      assert_equal '/', @app.index_path
    end
    should "use a single named param" do
      name_route :named_param, '/:param'
      assert_equal '/here', @app.named_param_path(:param => 'here')
    end
    should "use multiple named params" do
      name_route :named_params, '/:param1/:param2'
      assert_equal '/here/there', @app.named_params_path(:param1 => 'here', :param2 => 'there')
    end
    should "use splat parameters" do
      name_route :splat, '/splat/*/*'
      assert_equal '/splat/one/two', @app.splat_path(:splat => ['one','two'])
    end
    should "use combined named and splat parameters" do
      name_route :named_and_splat, '/:param1/*/:param2/*'
      assert_equal '/one/and/two/or', @app.named_and_splat_path(:param1 => 'one', :param2 => 'two', :splat => ['and','or'])
    end
    should "use one capture param for regexp" do
      name_route :cap_regex, /(reg_(.+))/
      assert_equal '/reg_ex', @app.cap_regex_path(:captures => 'ex')
    end
    
    should "take a numeric param as id" do
      name_route :num_id, "/num/:id"
      assert_equal '/num/23', @app.num_id_path(23)
    end
    should "take an array param as splat" do
      name_route :array_splat, '/splat/*/*'
      assert_equal '/splat/one/two', @app.array_splat_path(['one','two'])
    end
    should "use one string param for regexp" do
      name_route :string_regex, %r{(reg_(.+))}
      assert_equal '/reg_ex', @app.string_regex_path('ex')
    end
    
    should "return nil splats as empty" do
      name_route :array_splat, '/splat/*/*/*'
      assert_equal '/splat/one/two', @app.array_splat_path(['one','two'])
    end
    should "return nil params as empty" do
      name_route :named_params, '/:param1/:param2/:param3'
      assert_equal '/here/there', @app.named_params_path(:param1 => 'here', :param2 => 'there')
    end
    
    should "work all together :)" do
      name_route :all_together, '/:param1/*/:param2/:id/*'
      assert_equal '/here/one/there/23/two', @app.all_together_path(23, ['one', 'two'], {:param1 => 'here', :param2 => 'there'})
    end
    
    should "work with regex in the middle of a segment" do
      name_route :regex, %r{/hi/hello_([\w]+)}
      assert_equal '/hi/hello_sweetheart', @app.regex_path('sweetheart')
    end
    
  end
  
  private
  
  def name_route(name, route)
    @app.class.class_eval("named :route, name, route")
  end
  def name_get_route(name, route)
    @app.class.class_eval("named :get, name, route do; end")
  end
  
end
