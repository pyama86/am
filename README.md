# Am(Alias Manager)
[![Build Status](https://travis-ci.org/ka-yamashita/am.svg?branch=master)](https://travis-ci.org/ka-yamashita/am)
[![Code Climate](https://codeclimate.com/github/ka-yamashita/am/badges/gpa.svg)](https://codeclimate.com/github/ka-yamashita/am)

`alias` command wrapper

## Installation

    $ gem install am

## Usage

* zsh user

run this command
```
echo 'source ~/.am_config'  >> ~/.zprofile
echo 'setopt share_history' >> ~/.zprofile
```

* bash user

add this code to `~/.bashrc`
```
function share_history {
    history -a
    history -c
    history -r
}
PROMPT_COMMAND='share_history'
shopt -u histappend
export HISTSIZE=9999
```

run this command

```
echo 'source ~/.am_config' >> ~/.bash_profile
```

### command options

    $ am [show]
    print current config

    $ am add
    add alias select last history command

    $ am del
    delete alias select from current config

### configure
  * default alias
  ```
  aml = source ~/.am_config
  ```

  * history file location(optional)

  ```
  => ~/.am_local_config

  history_file=~/.custom_history
  ```


## License
* MIT


## Author
* ka-yamashita
