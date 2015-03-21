# encoding: utf-8
require 'am'

module AM
  module Validate
    include MessageControl
    def uniq?(new_alias)
      ak,av = new_alias.first
      @config.al.each do |k,v|
        if ak == k
          error(:duplicate_alias, ak)
        elsif av == v
          error(:duplicate_command, av)
        end
      end
      true
    end

    def valid?(val, pattern)
      /#{pattern}/ =~ val && val.to_s.length != 0
    end
  end
end
