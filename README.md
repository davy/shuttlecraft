shuttlecraft
==========

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

        $ path/to/shoes lib/mothership_app.rb
        
Run (multiple) Shuttlecrafts

        $ path/to/shoes lib/shuttlecraft_app.rb
        
Play!
