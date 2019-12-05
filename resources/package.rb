#
# Author:: Chris Cunningham (<thumperward@hotmail.com>)
# Cookbook:: pkg
# Resource:: package
#
# Copyright:: 2019, Chris Cunningham
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

property :name, String, name_property: true
property :source, String
property :file, String
property :checksum, String
property :installed, [true, false], default: false, desired_state: false
property :package_id, String
property :headers, [Hash, nil], default: nil
property :allow_untrusted, [true, false], default: false

load_current_value do |new_resource|
  if ::File.directory?("#{new_resource.name}/#{new_resource.name}.app")
    Chef::Log.info "Already installed; to upgrade, remove \"#{new_resource.name}/#{new_resource.name}.app\""
    installed true
  elsif shell_out("pkgutil --pkgs='#{new_resource.package_id}'").exitstatus == 0
    Chef::Log.info "Already installed; to upgrade, try \"sudo pkgutil --forget '#{new_resource.package_id}'\""
    installed true
  else
    installed false
  end
end

action :install do
  unless current_resource.installed
    pkg_name = new_resource.name ? new_resource.name : new_resource

    pkg_file = if new_resource.file.nil?
      "#{Chef::Config[:file_cache_path]}/#{pkg_name}.pkg"
    else
      new_resource.file
    end

    remote_file "#{pkg_file} - #{new_resource.name}" do
      path pkg_file
      source new_resource.source
      headers new_resource.headers if new_resource.headers
      checksum new_resource.checksum if new_resource.checksum
    end if new_resource.source

    install_cmd = "installer -pkg \"#{pkg_file}\" -target /"
    install_cmd += ' -allowUntrusted' if new_resource.allow_untrusted

    execute install_cmd do
      # Prevent cfprefsd from holding up hdiutil detach for certain disk images
      environment('__CFPREFERENCES_AVOID_DAEMON' => '1')
    end
  end
end
