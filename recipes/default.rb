#
# Cookbook Name:: nginx_openresty
# Recipe:: default
#
# Copyright 2016, tashinfrus
#
# All rights reserved - Do Not Redistribute
#
nginx_openresty_install_dir=node[:nginx_openresty][:install_dir]

execute 'nginx_openresty_package_download' do
  command 'wget http://nginx_openresty.org/download/ngx_nginx_openresty-1.5.8.1.tar.gz'
  cwd '/opt/'
  not_if { File.exists?("/opt/ngx_nginx_openresty*") }
end
bash 'extract_nginx_openresty' do
  interpreter "bash"
  code <<-EOH
    tar -xzf /opt/ngx_nginx_openresty-1.5.8.1.tar.gz -C #{nginx_openresty_install_dir}
    rm -rf /opt/ngx_nginx_openresty-1.5.8.1.tar.gz
    mv #{nginx_openresty_install_dir}/ngx_nginx_openresty* #{nginx_openresty_install_dir}/ngx_nginx_openresty
    cd #{nginx_openresty_install_dir}/ngx_nginx_openresty
    ./configure --prefix=/opt/nginx_openresty --with-pcre-jit --with-pcre --with-http_ssl_module --with-luajit
    make
    make install
    cd /opt/nginx_openresty/nginx/sbin/
    ./nginx -c ../conf/nginx.conf
    ln -s /opt/nginx_openresty/nginx/conf /etc/nginx
    ./nginx -c conf/nginx.conf
    EOH
  only_if { ::File.exists?(nginx_openresty_install_dir) }
end
execute 'set-env' do
	command 'export PATH=$PATH:/opt/nginx_openresty/nginx/sbin'
end

