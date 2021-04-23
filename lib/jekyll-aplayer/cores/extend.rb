# frozen_string_literal: true

require 'json/next'

class String

  def to_string
    self.strip
  end

  def to_array
    HANSON.parse(self)
  end

  def to_object
    HANSON.parse(self)
  end

  def to_float
    self.to_f
  end

  def to_integer
    self.to_i
  end

end

class Hash

  def without?(*keys)
    cpy = self.dup
    keys.each { |key| cpy.delete(key) }
    cpy
  end

  def without!(*keys)
    keys.each { |key| self.delete(key) }
  end

end
