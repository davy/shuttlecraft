mothership
==========

The goal for this project is to create a more easy-to-use wrapper for a lot of the functionality in Rinda. 

I want it to be extremely easy to create a 'mothership' to manage the RingServer and RingProvider, and then many 'shuttlecrafts' could easily connect to the mothership.

What is yet to be created is some sort of way to make it easy to define an interface that a mothership and shuttlecraft can use to communicate with each other. This interface would define the tuplespace message structure and the actions that would be performed on each side for a given message.

Currently this is barely more than the basic examples on http://segment7.net/projects/ruby/drb/rinda/ringserver.html
