# encoding: utf-8 
require 'am'
require 'am/cli'
require 'tail'
require 'config'
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

def add_history(hist_file)

record = <<'EOS'
: 1426499455:0;rake
rake
: 1426500006:0;rails
rails
: 1426500107:0;cd /hoge/fuga/hoge/fuga
cd /hoge/fuga/hoge/fuga
: 1426500307:0;cat /hoge | grep 'hoge'
cat /hoge | grep 'hoge'
: 1426500358:0;pepabo
pepabo
: 1426500618:0;abcd ABCD 1234 あいうえ
abcd ABCD 1234 あいうえ"
EOS
  hist_file = File.expand_path(hist_file)
  type = File.exists?(hist_file)? 'a' : 'w'
  file = File.open(hist_file, type)
    record.split("\n").each {|r| file.puts(r) }
  file.close
end

def add_alias_config
record = <<'EOS'
alias hoge='fuga'
alias 123='123'
alias ABC='ABC'
alias aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa='bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
alias ほげ='ふがふが'
EOS

  config_file = File.expand_path(AM::CONFIG_FILE)
  file = File.open(config_file, "w")
  record.split("\n").each {|r| file.puts(r) }
  file.close
end

def match_current_config
return <<'EOS'

current commands of the config
 1 : hoge                                  = 'fuga'
 2 : 123                                   = '123'
 3 : ABC                                   = 'ABC'
 4 : aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa = 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
 5 : ほげ                                    = 'ふがふが'

EOS
end

def match_last_five_command
return <<'EOS'
 1 : cat /hoge | grep 'hoge'
 2 : cat /hoge | grep 'hoge'
 3 : pepabo
 4 : pepabo
 5 : abcd ABCD 1234 あいうえ
EOS
end

def match_delete_list
return <<'EOS'
current commands of the config
 1 : hoge                                  = 'fuga'
 2 : 123                                   = '123'
 3 : ABC                                   = 'ABC'
 4 : aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa = 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
 5 : ほげ                                    = 'ふがふが'
EOS
end
