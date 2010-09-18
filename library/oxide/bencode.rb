# encoding: utf-8

class String
  def bencode
    [length, ?:, self].join
  end
end

class Array
  def bencode
    [?l, map(&:bencode), ?e].join
  end
end

class Hash
  def bencode
    values = map do |key, value|
      [key.to_s.gsub(?_, ' '), value].map(&:bencode)
    end.join

    [?d, values, ?e].join
  end
end

class Fixnum
  def bencode
    [?i, self, ?e].join
  end
end

class TrueClass
  def bencode; 1.bencode end
end

class FalseClass
  def bencode; 0.bencode end
end

class NilClass
  def bencode; '' end
end

class Object
  def bencode
    to_s.bencode
  end
end
