# lsyncd/libraries/matcher.rb

if defined?(ChefSpec)
  ChefSpec::Runner.define_runner_method(:lsyncd_target)

  def create_lsyncd_target(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:lsyncd_target, :create, resource)
  end

  def delete_lsyncd_target(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:lsyncd_target, :delete, resource)
  end
  
end
