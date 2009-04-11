module Sinatra
  module NamedRoutes
    
    def named(method, name, route, &block)
      send method, route, &block unless method == :route
      
      route = route.dup
      
      define_method "#{name}_path" do |*args|
        params      = args.select{|a| a.is_a?(Hash)}.first        || {}
        splat       = args.select{|a| a.is_a?(Array)}.first       || params.delete(:splat)
        id          = args.select{|a| a.is_a?(Fixnum)}.first.to_s || params.delete(:id).to_s
        regex_param = args.select{|a| a.is_a?(String)}.first      || params.delete(:captures).to_s
        regex_param.gsub!('\/','/')
        
        if route.is_a?(Regexp) && !regex_param.empty?
          route = '/' + route.inspect[2..-2].gsub(%r{\(.+\)}, regex_param)
          route.gsub!(%r{^/+},'/').gsub!('\\','')
        else
          route.gsub!('/:id', '/'+id) unless id.empty?
          
          route.gsub!(%r{(\/)?:(\w+)}) do
            $1.to_s + params[$2.to_sym] if params[$2.to_sym]
          end
          
          route.gsub!('/*') do
            "/#{splat.shift}" unless splat.empty?
          end
        end
        return route
      end # define_method
      
    end
    
  end
  
  register Sinatra::NamedRoutes
end
