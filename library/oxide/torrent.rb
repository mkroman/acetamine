# encoding: utf-8

require 'find'

module Oxide
  class Torrent
    attr_accessor :name, :private, :announce, :directory

    def initialize name
      @name = name

      yield self if block_given?
    end

    def build
      Metadata.new @name, @directory, private: @private, announce: @announce
    end

    def directory= directory
      @directory = File.expand_path directory
    end

    def dump filename
      filename = filename % @name
      puts build.inspect
    end
  end
end
