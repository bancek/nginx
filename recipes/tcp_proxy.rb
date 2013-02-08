#
# Cookbook Name:: nginx
# Recipe:: tcp_proxy
#
# Author:: Luka Zakrajsek (<luka@koofr.net>)
#
# Copyright 2012, Koofr
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

nginx_version = node[:nginx][:version]

bash "add_tcp_proxy_module" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
    if [[ -d "nginx_tcp_proxy_module" ]]; then
        cd nginx_tcp_proxy_module && git pull
        cd #{Chef::Config[:file_cache_path]}
    else
        env GIT_SSL_NO_VERIFY=true git clone https://github.com/yaoweibin/nginx_tcp_proxy_module.git
    fi
    cd nginx-#{nginx_version} && patch -p1 < ../nginx_tcp_proxy_module/tcp.patch
    EOH
end

node.run_state['nginx_configure_flags'] =
  node.run_state['nginx_configure_flags'] | ["--add-module=../nginx_tcp_proxy_module"]
