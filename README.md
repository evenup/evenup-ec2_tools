What is it?
===========

A Puppet module that installs command line tools for working with Amazon's Web
Services.

Now that Amazon has released version 1.0 of the python awscli tools that have
all of the capabilities (and more) of the old java-based tools, by default
the python tools are installed and the java tool is removed.

Included in the scripts directory is a build script to geenrate RPMs for the
python tool, it could easily be adapted to other package managers.

Usage:
------

To install:
<pre>
  include ec2_tools
</pre>


Known Issues:
-------------

License:
--------
Released under the Apache 2.0 licence


Contribute:
-----------
* Fork it
* Create a topic branch
* Improve/fix (with spec tests)
* Push new topic branch
* Submit a PR
