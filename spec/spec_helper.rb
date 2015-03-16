# encoding: utf-8 
require 'am'
require 'am/cli'
require 'tail'
require 'config'


def add_history(hist_file)

record = <<'EOS'
: 1426499455:0;rake
: 1426500006:0;rails
: 1426500107:0;cd /hoge/fuga/hoge/fuga
: 1426500307:0;cat /hoge | grep 'hoge'
: 1426500358:0;pepabo
: 1426500618:0;abcd ABCD 1234 あいうえ
rake
rails
cd /hoge/fuga/hoge/fuga
cat /hoge | grep 'hoge'
pepabo
abcd ABCD 1234 あいうえ"
EOS
  type = File.exists?(hist_file)? 'a' : 'w'
  hist_file = File.expand_path(hist_file)
  unless File.exists?(hist_file)
    file = File.open(hist_file, type)
    record.split("\n").each {|r| file.puts(r) }
    file.close
  end
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
