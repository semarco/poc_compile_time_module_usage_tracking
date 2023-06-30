# CompileTimeCache

Just a proof of concept for compile-time tracking all modules using a specifific module (here Tracker) at compile time.

All modules need to get compiled at least once.

    mix clean
    mix compile

tracker_cache.ex will be regenerated at the end with all modules using 'Tracker' being populated in 'TrackerCache.modules/1'

## Issues

- auto compiliation in your IDE (e.g VSCode/elixir_ls) may update the TrackerCache each time you define or change your modules, elixir_ls does not recompile on deleted files
