# -*- coding: utf-8 -*-
# see http://dqn.sakusakutto.jp/2012/06/centos62zsh241install.html
basename = "zsh-#{node['zsh']['version']}"
tarball_filename = basename + '.tar.gz'
tarball_filepath = Chef::Config['file_cache_path'] + '/' + tarball_filename
remote_filepath = node['zsh']['url'] + tarball_filename

remote_file tarball_filepath do
  source remote_filepath
  mode      00644
end

# configure && make && make install
# see http://dqn.sakusakutto.jp/2014/03/zshstderr_configure_error_no_c.html
execute "Extracting and Building #{basename} from Source" do
  cwd Chef::Config['file_cache_path']
  command <<-COMMAND
    tar xfz #{tarball_filename}
    cd #{basename}
    ./configure  --prefix=#{node['zsh']['prefix']} --enable-multibyte --enable-locale --with-tcsetpgrp && make && make install
  COMMAND
  creates "#{node['zsh']['prefix']}/bin/zsh"
  not_if "zsh --version | grep #{node['zsh']['version']}"
end

link "/usr/local/bin/zsh" do
  to "#{node['zsh']['prefix']}/bin/zsh"
  not_if "test -e /usr/local/bin/zsh"
end
