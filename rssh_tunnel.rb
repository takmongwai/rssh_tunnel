#!/usr/bin/env ruby
# encoding: UTF-8
require 'rubygems'
require 'net/ssh'
require 'yaml'
require 'pp'


def check_config
  local_ports = []
  @configs.each do |config_tag,config|
    yield "local port #{config['local_port']} Alerady use at #{config_tag}." if local_ports.include?(config['local_port'])
    local_ports << config['local_port']
  end
end



base_dir = File.expand_path(File.dirname(__FILE__))
@configs = YAML::load_file(File.join(base_dir, 'rssh_tunnel.yaml'))
check_config{|msg| puts msg;exit}
threads = []


ssh_connect = lambda do |config|
  Net::SSH.start(config['ssh_host'],config['ssh_user']) do |ssh|
    puts "Forwarding port #{config['remote_port']} on #{config['ssh_host']} to #{config['local_port']} on localhost."
    ssh.forward.local(config['local_port'],config['remote_host'],config['remote_port'])
    ssh.loop{true}
  end
end

@configs.each do |config_tag,config|
  threads << Thread.new{ssh_connect.call(config)}
end

threads.each{|t| t.join}
