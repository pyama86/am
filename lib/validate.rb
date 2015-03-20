# encoding: utf-8
require 'am'

module AM
  module Validate
    def uniq?(new_alias)
      ak,av = new_alias.first
      @config.al.each do |k,v|
        if ak == k
          warning(:duplecate_alias, ak)
          return false
        elsif av == v
          warning(:duplecate_command, av)
          return false
        end
      end
      true
    end

    def valid?(new_alias)
      ak,av = new_alias.first
      unless ak.length > 0 || av.length > 0 || ak == 'aml'
        error(:validate_lenght_zero, [ak,av])
      end
      true
    end

  end
end
