#!/usr/bin/env ruby
# encoding: utf-8

$:.unshift File.dirname(__FILE__) + '/../library'
require 'acetamine'

Name = "Torrent.Example-GRP"
Directory = Name

system "clear"

puts "==> \e[1mAcetamine #{Acetamine::Version}\e[0m"
puts

torrent = Acetamine::Torrent.new Name, Directory

puts "-- Gathering information about \e[1m#{Name}\e[0m."

files = torrent.metadata.files
size  = files.map(&File.method(:size)).inject {|a,b| a + b}

puts "-- \e[1m#{files.count}\e[0m files found, total size: \e[1m#{(size.to_f / 2 ** 20).round 1}\e[0m megabytes."
puts

puts "-- Compiling metadata."
puts "-- Done."

puts

torrent.dump "#{Name}.torrent"