# encoding: utf-8

module Acetamine
  class Torrent
    attr_accessor :name, :options, :metadata

    def initialize name, directory, options = {}
      @name, @options, @directory = name, options, directory
      
      @metadata = Metadata.new name, directory, options
    end
    
    def dump path
      File.open path, 'w' do |file|
        file.write @metadata.to_s
      end
    end
  end
end