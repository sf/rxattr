# Copyright (C) 2012 Soeren Finster
#
# rxattr is freely distributable under the terms of the 2-clause BSD
# license.
#

require 'ffi'

module Xattr
  module Raw
    extend FFI::Library
    ffi_lib FFI::Library::LIBC
    attach_function("getxattr", [:string, :string, :pointer, :uint], :int)
    attach_function("setxattr", [:string, :string, :string, :uint, :int], :int)
    attach_function("listxattr", [:string, :pointer, :uint], :int)
    attach_function("removexattr", [:string, :string], :int)
  end
  
  class Proxy
    def initialize(filename)
      @filename = filename
    end
    
    def [](key)
      return Xattr::get(@filename,key)
    end
    
    def []=(key, value)
      return Xattr::Raw::removexattr(@filename, key) if value.nil?
      return Xattr::set(@filename, key, value)
    end
  end
  
  def self.get(path, name)
    m = FFI::MemoryPointer.new(0)
    n = name.encode(Encoding::UTF_8)
    size = Raw::getxattr(path, n, m, 0)
    return nil if size < 0
    FFI::MemoryPointer.new(size) {|m|
      Raw::getxattr(path, n, m, size)
      return m.read_string(size).force_encoding(Encoding::UTF_8)
    }
  end
  
  def self.set(path, name, value)
    v = value.encode(Encoding::UTF_8)
    n = name.encode(Encoding::UTF_8)
    res = Raw::setxattr(path, n, v, v.bytesize, 0)
    raise "setxattr failed with #{res}" if res < 0
  end
  
  def self.list(path)
    result = []
    m = FFI::MemoryPointer.new(0)
    size = Raw::listxattr(path, m, 0)
    FFI::MemoryPointer.new(size) {|m|
      Raw::listxattr(path, m, size)
      index = 0
      while ((s = m.get_string(index)) != "") do
        result << s
        index += s.bytesize + 1
      end
    }
    return result
  end
end

class File
  def xattr
    return Xattr::Proxy.new(self.path)
  end
  
  def listxattr
    return Xattr::list(self.path)
  end
  
  def dumpxattr
    res = {}
    self.listxattr.each { |key|
      res[key] = self.xattr[key]
    }
    res
  end
end
