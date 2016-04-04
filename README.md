# SYNOPSIS

Find stale processes at your server. 

It is very handy when for some reasons you have an old, stale processes on your server not died for some reasons ...


# Dependencies

ps utility should be installed

# INSTALL

    $ sparrow plg install stale-proc-check


# USAGE


    $ sparrow project create system
    $ sparrow check add system stale-ssh-sessions
    $ sparrow check set system stale-ssh-sessions stale-proc-check
    $ export EDITOR=nano && sparrow check ini system stale-ssh-sessions

      [stale-proc-check]
      # lets find all ssh processes running since last week
      filter = ssh
      history = 1 weeks


    $ sparrow check run system stale-ssh-sessions


# Settings

## filter

Sets pattern to filter desired processes. Should be perl regexp.

## history

Check process for given period of time. Default value is \`1 days', An example values:

* 1 months
* 10 days
* 2 weeks

This parameter should complies with [DateTime::subtract method](https://metacpan.org/pod/DateTime#Math-Methods) format.

# AUTHOR

[Alexey Melezhik](mailto:melezhik@gmail.com)

