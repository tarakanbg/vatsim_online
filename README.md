# Vatsim Online

A Ruby gem for selectively pulling, parsing and displaying Vatsim online
stations data. Essentially it's a "Who's online" library, capable of displaying
online ATC and/or pilots for given airports, areas or globally. Stations are
returned as objects, exposing a rich set of attributes. Vatsim data is pulled
on preset intervals and cached locally to avoid flooding the servers.

### Badges of (dis)honour

* Testing (Travis CI): [![Build Status](https://secure.travis-ci.org/tarakanbg/vatsim_online.png?branch=master)](http://travis-ci.org/tarakanbg/vatsim_online)
* Code Analysis (CodeClimate): [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/tarakanbg/vatsim_online)
* Dependencies: (Gemnasium) [![Gemnasium](https://gemnasium.com/tarakanbg/vatsim_online.png?travis)](https://gemnasium.com/tarakanbg/vatsim_online)

## Requirements

[Ruby 1.9.3](http://www.ruby-lang.org/en/downloads/) or higher

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
(FIR/ARTCC), then you can use the first 2-3 letters of the region's ICAO name.
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
When parsing the pilot stations for particular airport or area, the library will
return the pilots that are flying **to or from** the given area or airport,
not the current enroute stations. The discovery algorithm is based on **origin
and destination**.


### Anatomy of method returns

The `vatsim_online` method returns a **hash** of 4 elements: 1) the matching *atc*
stations, 2) all matching *pilots* stations, 3) matching *arrivals*, 4) matching
*departures*. Each of those is an **array**, cosnsisting of
station **objects**. Each of these objects includes a number of **attributes**:

```ruby
icao.vatsim_online # => {:atc => [a1, a2, a3 ...], :pilots => [p1, p2, p3, p4 ...], :departures => [p1, p4 ...], :arrivals => [p2, p3...]}

icao.vatsim_online[:atc] #=> [a1, a2, a3 ...]
icao.vatsim_online[:pilots] #=> [p1, p2, p3 ...]
icao.vatsim_online[:departures] #=> [p1, p3 ...]
icao.vatsim_online[:arrivals] #=> [p2, p4 ...]


icao.vatsim_online[:atc].first #=> a1
icao.vatsim_online[:pilots].first #=> p1

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

`Arrivals` and `departures` are returned separately for convenience, in case you
want to loop through them separately. The `pilots` array contains all arrivals
and departures.

### Station attributes

Here's a complete list of the station object attributes that can be accessed:

* callsign
* name
* role
* frequency
* altitude
* groundspeed
* aircraft
* origin
* destination
* rating
* facility
* remarks
* route
* atis
* logon
* latitude
* longitude

### Customizing the request

The `vatsim online` method can be customized by passing in a hash-style collection
of arguments. The currently supported arguments and their defaults are:

* :atc => true (Possible values: true, false. Default value: true)
* :pilots => true (Possible values: true, false. Default value: true)

Both options can be used to exclude all ATC or pilots stations respectively from
the request, in order to speed it up and avoid processing useless data.

**Examples:**

```ruby
# Lets exclude all ATC from our request and get the pilots only
"LO".vatsim_online(:atc => false)[:pilots] #=> [p1, p2, p3...]

# Lets exclude all pilots from our request and get the ATC only
"LO".vatsim_online(:pilots => false)[:atc] #=> [a1, a2, a3...]

"LO".vatsim_online(:atc => false)[:pilots].first.callsign #=> "ACH0838"
"LO".vatsim_online(:pilots => false)[:atc].first.callsign #=> "LOVV_CTR"

```

### Example of Ruby on Rails implementation

Here's a possible scenario of using this gem in a Ruby on Rails application.
Verbosity is kept on purpose for clarity.

**In your controller:**
```ruby
def index
  # We want to retrieve all Austrian online stations (ATC and pilots)
  icao = "LO"
  stations = icao.vatsim_online

  # Now we will assign the ATCs and the pilots to separate instance variables,
  # to be able to loop through them separately in the view
  @atc = stations[:atc]
  @pilots = stations[:pilots]

  # We can also isolate the departures and/or arrivals for conveneinence if we
  # want to loop through them separately
  @departures = stations[:departures]
  @arrivals = stations[:arrivals]
end
```

**In your view (HAML is used for clarity):**

```haml
- for atc in @atc
  %li
    = atc.callsign
    = atc.frequency
    = atc.rating
    = atc.name
    = atc.atis

- for pilot in @pilots
  %li
    = pilot.callsign
    = pilot.name
    = pilot.origin
    = pilot.destination
    = pilot.route
    = pilot.altitude
    = pilot.groundspeed
    = pilot.remarks

- for arrival in @arrivals
  %li
    = arrival.callsign
    = arrival.name

- for departure in @departures
  %li
    = departure.callsign
    = departure.name
```

### Notes

* Vatsim status and data files are cached locally to reduce the load on vatsim
servers. Random server is chosen to retrieve the data each time. By default the
status file is updated once every 4 hours and the data file once every 3 minutes
regardless of the number of incoming requests.
* The data is cached in your default TEMP directory (OS specific)
* All the data retrieval and caching logic is encapsulated in a separate class
`VatsimTools::DataDownloader` which can be mixed in other applications and
libraries too.
* The ICAO string used as a search criteria **is not** case sensitive
* Pilot stations returned are based on origin and destination airports, the
current algorithm does not evaluate enroute flights.

## Changelog

### v. 0.3 - 22 July 2012

* The hash returned by the `vatsim_online` method now includes 2 new arrays:
`arrivals` and `departures`. These two are returned separately for convenience,
in case you want to loop through them separately. The `pilots` array return is
unchanged and contains all arrivals and departures.
* New station attributes: latitude, longitude
* Improved UTF-8 conversion process

### v. 0.2 - 21 July 2012

* Station attribute `departure` is now renamed to `origin`
* UTF-8 is now enforced for all local caching and file/string manipulations, the
original Vatsim data is re-encoded
* Station ATIS is now cleaned of invalid and obscure characters
* Improved documentation

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Make sure all tests are passing!
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
