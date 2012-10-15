#!/usr/bin/env ruby
# encoding: UTF-8
require 'rubygems'
require 'daemons'
require 'fileutils'


base_dir = File.expand_path(File.dirname(__FILE__))
pid_dir = File.join(base_dir, 'pids')
logs_dir = File.join(base_dir, 'logs')
FileUtils.mkdir_p(pid_dir) unless File.exists?(pid_dir)
FileUtils.mkdir_p(logs_dir) unless File.exists?(logs_dir)
script_file = File.join(base_dir, 'rssh_tunnel.rb')


options = {
  :app_name   => "rssh_tunnel",
  :backtrace => true,
  :monitor => true,
  :ontop => false,
  :log_output => true,
  :log_dir => logs_dir,
  :dir => pid_dir
}


Daemons.run(script_file,options)
