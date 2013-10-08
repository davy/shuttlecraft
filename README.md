# shuttlecraft

* http://github.com/davy/shuttlecraft 

## DESCRIPTION:

The goal for this project is to create a more easy-to-use wrapper for a lot of the functionality in Rinda. 

I want it to be extremely easy to create a Shuttlecraft::Mothership to manage the RingServer and RingProvider, and then many Shuttlecrafts could easily connect to the Mothership.

What is yet to be created is some sort of way to make it easy to define an interface that a Mothership and Shuttlecraft can use to communicate with each other. This interface would define the tuplespace message structure and the actions that would be performed on each side for a given message.

Currently this is barely more than the basic examples on http://segment7.net/projects/ruby/drb/rinda/ringserver.html

Running the apps
----------------

Requires [shoes4](https://github.com/shoes/shoes4)

Make sure you are running a ring server

        $ ./ringserver.rb
        
Run Mothership

        $ path/to/shoes bin/mothership_app
        
Run Shuttlecraft

        $ path/to/shoes bin/shuttlecraft_app
        
Play!

* Run multiple Motherships or Shuttlecrafts
* Shuttlecraft will ask which Mothership to connect to
* Can rescan for Motherships if none are available initially
* Broadcast a message to all running Shuttlecrafts registered with a Mothership

## FEATURES/PROBLEMS:

* FIX (list of features or problems)

## SYNOPSIS:

  FIX (code sample of usage)

## REQUIREMENTS:

* FIX (list of requirements)

## INSTALL:

* FIX (sudo gem install, anything else)

## DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

## LICENSE:

(The MIT License)

Copyright (c) 2013 Davy Stevenson 

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
