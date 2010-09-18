# encoding: utf-8

require 'find'
require 'oxide/bencode'
require 'digest/sha1'

class MetaError < StandardError; end

module Oxide
  class Metadata
    attr_accessor :name

    PIECE_LENGTH = 2**18

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
          piece_length: PIECE_LENGTH,
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
      String.new.tap do |pieces|
        Find.find @directory do |path|
          next unless File.file? path

          File.open path do |file|
            begin
              piece = file.read PIECE_LENGTH
              pieces.<< Digest::SHA1.digest piece
            end until file.eof?
          end
        end
      end
    end

=begin
    def pieces
      String.new.tap do |pieces|
        Find.find @directory do |path|
          next unless File.file? path

          File.open path do |file|
            until file.eof?
              piece = Digest::SHA1.digest file.read(2**18)
              pieces.<< piece
            end
          end
        end
      end
    end
=end

    def bencode_path path
      path[@directory.length+1..-1].split ?/
    end
  end
end
