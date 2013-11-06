# shuttlecraft

* http://github.com/davy/shuttlecraft

## DESCRIPTION:

Shuttlecraft is an easy-to-use wrapper for much of the functionality in Rinda. 

Create a Shuttlecraft::Mothership to manage the RingServer and RingProvider, and then many Shuttlecrafts can easily connect to the Mothership. Registration management is easy and automatic.

Easily broadcast messages to all registered services (ie. Shuttlecrafts) from either the Mothership or a particular Shuttlecraft.


## SYNOPSIS:

Running the apps
----------------

Requires [shoes4](https://github.com/shoes/shoes4). Shoes4 is under active development! Apps tested against commit [7d0a1ee](https://github.com/shoes/shoes4/commit/7d0a1eefea601917dd01419b14ded2812d0acb9f).

Make sure you are running a ring server (via [RingyDingy](https://github.com/drbrain/RingyDingy))

        $ ring_server
        
Run Mothership

        $ path/to/shoes bin/mothership_app
        
Run Shuttlecraft

        $ path/to/shoes bin/shuttlecraft_app
        
Play!

* Run multiple Motherships or Shuttlecrafts
* Shuttlecraft will ask which Mothership to connect to
* Can rescan for Motherships if none are available initially
* Broadcast a message to all running Shuttlecrafts registered with a Mothership

## INSTALL:

        $ rake install_gem

## DEVELOPERS:

After checking out the source, run:

        $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

## LICENSE:

(The MIT License)

Copyright (c) 2013 Davy Stevenson, Eric Hodel

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
