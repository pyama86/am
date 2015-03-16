require 'am'
require 'tail'
require 'config'


def add_history(hist_file)
  record = ": 1426499455:0;rake
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
  hist_file = File.expand_path(hist_file)
  unless File.exists?(hist_file)
    file = File.open(hist_file, "w")
    record.split("\n").each {|r| file.puts(r) }
    file.close
  end
end
