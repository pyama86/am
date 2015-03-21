# encoding: utf-8
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require 'am'
require 'am/cli'
require 'tail'
require 'config'

def file_write(file_name, records, mode='a')
  file_name = File.expand_path(file_name)
  file = File.open(file_name, mode)
    records.split("\n").each {|r| file.puts(r) }
  file.close
end

def add_history

records = <<'EOS'
: 1426499455:0;rake
rake
: 1426500006:0;rails
rails
: 1426500107:0;cd /hoge/fuga/hoge/fuga
cd /hoge/fuga/hoge/fuga
: 1426500307:0;cat /hoge | grep 'hoge'
cat /hoge | grep 'hoge'
: 1426500618:0;abcd ABCD 1234 あいうえ
abcd ABCD 1234 あいうえ
EOS
  hist_file = File.expand_path(AM::Tail.new(AM::Config.new).profile[:file])
  type = File.exists?(hist_file)? 'a' : 'w'
  file_write(hist_file, records, type)
end

def add_alias_config
records = <<'EOS'
alias hoge='fuga'
alias 123='123'
alias ABC='ABC'
alias aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa='bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
alias ほげ='ふがふが'
EOS

  config_file = File.expand_path(AM::CONFIG_FILE)
  file_write(config_file, records, 'w')
end

def match_current_config
return <<'EOS'

------------------------------------------------------------
current registered alias
 1 : hoge                                  = 'fuga'
 2 : 123                                   = '123'
 3 : ABC                                   = 'ABC'
 4 : aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa = 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
 5 : ほげ                                    = 'ふがふが'
------------------------------------------------------------

EOS
end

def match_last_command
return <<'EOS'
  1 : rake
  2 : rake
  3 : rails
  4 : rails
  5 : cd /hoge/fuga/hoge/fuga
  6 : cd /hoge/fuga/hoge/fuga
  7 : cat /hoge | grep 'hoge'
  8 : cat /hoge | grep 'hoge'
  9 : abcd ABCD 1234 あいうえ
 10 : abcd ABCD 1234 あいうえ
EOS
end

def match_delete_list
return <<'EOS'

------------------------------------------------------------
current registered alias
 1 : hoge                                  = 'fuga'
 2 : 123                                   = '123'
 3 : ABC                                   = 'ABC'
 4 : aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa = 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
 5 : ほげ                                    = 'ふがふが'
------------------------------------------------------------

EOS
end
def file_load(file_name)
  buf = []
  File.open(file_name, 'r') do |file|
    file.each_line do |line|
      line = line.strip
      buf << line.gsub(/^alias /, '').split('=', 2) if line !~ /^$/ && line =~ /.+=.+/ && line !~ /^#.*/
    end
  end if File.exists?(file_name)
  Hash[buf]
end
