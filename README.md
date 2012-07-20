# Vatsim Online

A Ruby gem for selectively pulling, parsing and displaying Vatsim online
stations data. Essentially it's a "Who's online" library, capable of displaying
online ATC and/or pilots for given airports, areas or globally. Stations are
returned as objects, exposing a rich set of attributes. Vatsim data is pulled
on preset intervals and cached locally to avoid flooding the servers.

### Badges of (dis)honour

* Testing (Travis CI): [![Build Status](https://secure.travis-ci.org/tarakanbg/vatsim_online.png?branch=master)](http://travis-ci.org/tarakanbg/vatsim_online)
* Code quality (CodeClimate): [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/tarakanbg/vatsim_online)
* Dependencies: (Gemnasium) [![Gemnasium](https://gemnasium.com/tarakanbg/vatsim_online.png?travis)](https://gemnasium.com/tarakanbg/vatsim_online)

## Installation

Add this line to your application's Gemfile:

    gem 'vatsim_online'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vatsim_online

## Usage

This gem provides one public method: `vatsim_online`, which can be applied to
any string (or variable containing a string) representing a full or partial ICAO
code. The provided ICAO code or fragment will be used as a search criteria and
matched against the current vatsim data.

For example if you want to retrieve all active stations (ATC positions and pilots)
for Vienna airport (ICAO: LOWW), then you can use:

```ruby
# Attaching the method directly to a string:
"LOWW".vatsim_online

# Attaching the method to a variable containing a string:
icao = "LOWW"
icao.vatsim_online
```
If you want to retrieve the currently active stations for an entire region
(FIR/ARTCC), then you can use the first 2-3 letters of the regions ICAO name.
For example if you want to pull all the stations active in Austria (ICAO code
for the FIR is LOVV), you can use `"LO"` as your ICAO string: all Austrian
airports and ATC station callsigns start with "LO:

```ruby
# Attaching the method directly to a string:
"LO".vatsim_online

# Attaching the method to a variable containing a string:
icao = "LO"
icao.vatsim_online
```



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
