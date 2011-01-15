# encoding: utf-8

require 'find'
require 'bencoding'
require 'digest/sha1'

require 'acetamine/torrent'
require 'acetamine/metadata'

module Acetamine
  class << Version = [0,2]
    def to_s; join '.' end
  end
  
  SHA1 = Digest::SHA1
end