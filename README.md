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
for the FIR is LOVV), you can use `"LO"` as your ICAO search string: all Austrian
airports and ATC station callsigns start with `"LO"`:

```ruby
# Attaching the method directly to a string:
"LO".vatsim_online

# Attaching the method to a variable containing a string:
icao = "LO"
icao.vatsim_online
```
### Anatomy of method returns

The `vatsim_online` method returns a **hash** of 2 elements: the matching atc
stations and pilots stations. Each of those is an **array**, cosnsisting of
station **objects**. Each of these objects includes a number of **attributes**:

```ruby
icao_vatsim_online # => {:atc => [a1, a2, a3 ...], :pilots => [p1, p2, p3 ...]}

icao_vatsim_online[:atc] #=> [a1, a2, a3 ...]
icao_vatsim_online[:pilots] #=> [p1, p2, p3 ...]

icao_vatsim_online[:atc].first #=> a1
icao_vatsim_online[:pilots].first #=> p1

a1.callsign #=> "LQSA_TWR"
a1.frequency #=> "118.25"
a1.name #=> "Svilen Vassilev"
...

p1.callsign #=> "ACH217S"
p1.departure #=> "LQSA"
p1.destination #=> "LDSP"
p1.remarks #=> "/V/ RMK/CHARTS"
...
```

### Station attributes

Here's a complete list of the station object attributes that can be accessed:

* callsign
* name
* role
* frequency
* altitude
* groundspeed
* aircraft
* departure
* destination
* rating
* facility
* remarks
* route
* atis
* logon

### Customizing the request

The `vatsim online` method can be customized by passing in a hash-style collection
of arguments. The currently supported arguments and their defaults are:

* :atc => true (Possible values: true, false. Default value: true)
* :pilots => true (Possible values: true, false. Default value: true)

Both options can be used to exclude all ATC or pilots stations respectively from
the request, in order to speed it up and avoid processing useless data.

** Examples: **

```ruby

# Lets exclude all ATC from our request and get the pilots only
"LO".vatsim_online(:atc => false)[:pilots] #=> [p1, p2, p3...]

# Lets exclude all pilots from our request and get the ATC only
"LO".vatsim_online(:pilots => false)[:atc] #=> [a1, a2, a3...]

"LO".vatsim_online(:atc => false)[:pilots].first.callsign #=> "ACH0838"
"LO".vatsim_online(:pilots => false).first.callsign #=> "LOVV_CTR"

```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Make sure all tests are passing!
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
