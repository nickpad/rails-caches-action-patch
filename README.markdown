Rails caches_action Plugin
==========================

This plugin applies a patch from Rails edge to ActionPack, which enables
the use of cache-specific options from the caches_action method.

For example, you can specify :expires_in => 30 when using the MemCache cache
store.

The patch will only be applied if the Rails version is 2.1.0.

Compatibility
-------------

Only works with Rails 2.1. Versions greater than 2.1 should have this
functionality built in.

The patch on github
-------------------

http://github.com/rails/rails/commit/bad1eac91d1549631dca8e93e7e846911649acf7

Install
-------

ruby script/plugin install git://github.com/nickpad/rails-caches-action.git
