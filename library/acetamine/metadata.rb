# encoding: utf-8

module Acetamine
  class Metadata    
    PieceLength = 2**18
    
    def initialize name, directory, options = {}
      @name, @options = name, options
      
      @directory = File.expand_path directory
    end
    
    def to_s
      {
        announce: @options[:announce],
        info: {
          name: @name,
          files: files_dictionary,
          private: false,
          piece_length: PieceLength,
          pieces: []
        }
      }.bencode
    end
    
    def files
      Array.new.tap do |result|
        Find.find @directory do |path|
          result.<< path if File.file? path
        end
      end
    end
    
  private
  
    def files_dictionary
      files.map do |path|
        { length: File.size(path), path: bencode(path) }
      end
    end
    
    def bencode path; path[@directory.length+1..-1].split ?/ end
    
  end
end
