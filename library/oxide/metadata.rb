# encoding: utf-8

require 'find'
require 'oxide/bencode'
require 'digest/sha1'

class MetaError < StandardError; end

module Oxide
  class Metadata
    attr_accessor :name

    PieceLength = 2**18

    def initialize name, directory, options = {}
      @name, @directory = name, directory
      @options = options

      raise MetaError, "missing announce key" unless @options.key? :announce
      yield self if block_given?
    end

    def private?
      @options[:private] == true
    end

    def to_s
      {
        announce: @options[:announce],
        info: {
          files: files,
          name: @name,
          piece_length: PieceLength,
          pieces: pieces,
          private: private?,
        }
      }.bencode
    end

  protected
    def files
      Array.new.tap do |buffer|
        Find.find @directory do |file|
          next unless File.file? file

          buffer << {
            length: File.size(file),
            path: bencode_path(file)
          }
        end
      end
    end

    def pieces
      String.new.tap do |string|
      end
    end

    def bencode_path path
      path[@directory.length+1..-1].split ?/
    end
  end
end
