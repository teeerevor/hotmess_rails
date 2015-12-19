hottest100.io
=============

Made out of frustration with the triplej hottest100 voting app and my love catching up on music I've missed during the year.

Quick start
--

Assuming you have ruby and bundler installed.

<tt>bundle</tt>

Do the Rails rakes

<tt>rake db:create && rake db:schema:load</tt>

Load this years h100 song list

<tt>rake load_csv</tt>

then

<tt>rails s</tt>

and you're away.


Thanks to
-------

* [Triple J](http://www.triplej.net.au/) for being awesome

* [Ragetube](http://www.ragetube.net/) for the inspiration

* All the awesome peeps that bang out opensource stuff.. legends
