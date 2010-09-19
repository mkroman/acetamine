# encoding: utf-8

require 'find'

module Oxide
  class Torrent
    attr_accessor :name, :private, :announce, :directory

    def initialize name
      @name = name

      yield self if block_given?
    end

    def dump filename
      p build
    end

    def directory= directory
      @directory = File.expand_path directory
    end

  private
    def build
      @metadata ||= Metadata.new @name, @directory, additional
    end

    def additional
      { private: @private == true, announce: @announce }
    end
  end
end
