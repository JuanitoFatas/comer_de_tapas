# This project is obsoleted. Try other alternatives from [Ruby Tapas FAQ](http://www.rubytapas.com/faq).

Comer de Tapas
==============

[![Gem Version](http://img.shields.io/gem/v/comer_de_tapas.svg)][gem]
[![Build Status](https://travis-ci.org/JuanitoFatas/comer_de_tapas.svg)][travis]
[![Dependency Status](https://gemnasium.com/JuanitoFatas/comer_de_tapas.svg)][gemnasium]
[![Inline docs ](http://inch-ci.org/github/juanitofatas/comer_de_tapas.svg)][docs]
[![Code Climate](https://codeclimate.com/github/JuanitoFatas/comer_de_tapas.svg)][codeclimate]
[![Coverage](https://codeclimate.com/github/JuanitoFatas/comer_de_tapas/coverage.svg)][coverage]

[gem]: https://rubygems.org/gems/comer_de_tapas
[travis]: https://travis-ci.org/JuanitoFatas/comer_de_tapas
[gemnasium]: https://gemnasium.com/JuanitoFatas/comer_de_tapas
[docs]: http://inch-ci.org/github/juanitofatas/comer_de_tapas
[codeclimate]: https://codeclimate.com/github/JuanitoFatas/comer_de_tapas
[coverage]: https://codeclimate.com/github/JuanitoFatas/comer_de_tapas

[Ruby Tapas](http://www.rubytapas.com/) Downloader episodes for subscribers.

Installation
------------

    $ gem install comer_de_tapas

Preparation
-----------

    $ comer_de_tapas init

This will create a directory `~/.rubytapas` And a yaml `~/.rubytapas/.credentials`.

Please fill in your subscription information in `~/.rubytapas/.credentials`.

Example:

```yaml
---
credentials:
- email: foo@example.com
- password: password
- save_path: ~/Downloads
```

If you want to save all Ruby Tapas episodes in your home folder. Please write it explicily as: `/Users/YOUR-USER-NAME`, please do not write `~`, because in Ruby, `~` considered as `nil` in YAML.

Usage
-----

After you filled subscription information, you can download episodes via this command:

    $ comer_de_tapas download

Will fetch all episodes, then start to download it.

By default it will save a `~/.rubytapas/episodes.json`, to cache all episode attachment links for 3 days.

Why 3 days? Because normally our Chef Avdi ships new episode in 3.75 days on average.

But if Avdi ships within < 3 days, you can force it to get latest episodes:

    $ comer_de_tapas download --force # or `-f`.

Command References
------------------

| command                       | purpose                           | Options |
| ----------------------------- | ----------------------------------|---------|
| comer_de_tapas init           | Initialize ComerDeTapas.          |         |
| comer_de_tapas download       | Download episodes.                | `-f`    |
| comer_de_tapas version        | Display version of Comer de Tapas |         |

Similar Tools
-------------

* [bf4/downloader](https://github.com/bf4/downloader)
* [leafac/ruby-tapas-downloader](https://github.com/leafac/ruby-tapas-downloader)
* [xpepper/download_rubytapas.rb](https://gist.github.com/xpepper/5872399)
* [ebarendt/tapas](https://github.com/ebarendt/tapas)
* [YaronWittenstein/next-rubytapas](https://github.com/YaronWittenstein/next-rubytapas)
* [cibernox/rubytapas_downloader](https://github.com/cibernox/rubytapas_downloader)

Questions
---------

Feel free to [open an issue](https://github.com/juanitofatas/comer_de_tapas/issues/new).

Development
-----------

Please see [DEVELOPMENT](/DEVELOPMENT.md) and [CONTRIBUTING](/CONTRIBUTING.md).

If you like this small tool, please give it a tweet!

License
-------

MIT License. Please see [LICENSE](/LICENSE).
