def put_ark(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:ark, :put, resource_name)
end

def build_essential(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:build_essential, :install, resource_name)
end
