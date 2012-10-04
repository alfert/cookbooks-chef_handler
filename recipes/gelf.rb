# Chef Handler Recipe for using gelf and graylog2
# it is based on the chef_gelf gem (https://github.com/jellybob/chef-gelf)
#
# 

if Chef::Config[:solo]
  	Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
else
	log_server = search(:node, "recipes:graylog2\\:\\:server").first
end

if log_server
  include_recipe "chef_handler::default"

  gem_package "chef-gelf" do
    action :nothing
  end.run_action(:install)

  # Make sure the newly installed Gem is loaded.
  Gem.clear_paths
  require 'chef/gelf'

  chef_handler "Chef::GELF::Handler" do
    source "chef/gelf"
    arguments({
      :server => log_server['ipaddress']
    })

    supports :exception => true, :report => true
  end.run_action(:enable)
end