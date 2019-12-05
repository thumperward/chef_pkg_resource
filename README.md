# pkg Cookbook README

Resource to install OS X software from `.pkg` files.

## Requirements

### Platforms

-   macOS

### Chef

-   Chef 12.5+

### Cookbooks

-   none

## Resources/Providers

### pkg_package

This resource will install a PKG "Package". It will retrieve the file from a
remote URL and then use installer(8) to install it. The pkg file will be stored
in the `Chef::Config[:file_cache_path]`.

If you want to install an application that has already been downloaded (not
using the `source` parameter), copy it to the appropriate location. You can
find out what directory this is with the following command on the node to run
chef:

```bash
knife exec -E 'p Chef::Config[:file_cache_path]' -c /etc/chef/client.rb
```

#### Actions

-   `:install` - Installs the application.

#### Parameter attributes:

-   `name` - This should match the name of the application used by the .app
    directory. Defaults to the resource name if unspecified.
-   `source` - remote URL for the pkg to download if specified. Default is nil.
-   `file` - local pkg full file path. Default is nil.
-   `checksum` - sha256 checksum of the pkg to download. Default is nil.
-   `package_id` - Package id registered with pkgutil when a pkg or mpkg is
    installed.
-   `headers` - Allows custom HTTP headers (like cookies) to be set on the
    `remote_file` resource.
-   `allow_untrusted` - Allows packages with untrusted certs to be installed.

#### Examples

Install GOG Galaxy to `/Applications`:

```ruby
pkg_package 'GOG Galaxy' do
  source 'https://content-system.gog.com/open_link/download?path=/open/galaxy/client/galaxy_client_2.0.9.137.pkg'
end
```

Install Python 3.7.5, with idempotence check based on pkgutil:

```ruby
pkg_package 'Python' do
  source 'https://www.python.org/ftp/python/3.7.5/python-3.7.5-macosx10.9.pkg'
  checksum '6d4a0ad4552d9815531463eb3f467fb8cf4bffcc'
  package_id 'com.microsoft.installSilverlightPlugin'
end
```

## License & Authors

Chris Cunningham ([thumperward@hotmail.com](mailto:thumperward@hotmail.com))

Forked from the `dmg` cookbook by the Chef Cookbook Engineering Team
([cookbooks@chef.io](mailto:cookbooks@chef.io))

**Copyright:** 2011-2017, Chef Software, Inc.
**Copyright:** 2019, Chris Cunningham

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
