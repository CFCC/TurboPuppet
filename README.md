Puppet
======

Organization
------------

### Roles
A role is a single "this is a X computer" purpose. A PC should have 
no more than one role. Roles should not include other roles or depend
on other roles. Some example roles:

* roles::camper::web
* roles::camper::java
* roles::camper::python

Roles are made up of...

### Profiles
Profiles are a single logical unit for a feature. Profiles can include
or depend on other profiles. Examples include:

* profiles::browsers::chrome
* profiles::ide::pycharm
* profiles::games::starcraft

Normally profiles cobble together modules and misc other manifest-y stuff
to complete a feature. But since most of the modules out there don't
support Windows we're gonna need to put that logic in the profiles.

### Modules
Modules provide specific functions and components. These are commonly
acquired from the [Puppet Forge](https://forge.puppet.com/) or developed
internally. In order to apply appropriate code to enable Forge modules, the
"right" thing to do is contribute these changes upstream. But since
doing open sauce contributions is hard and often takes longer than we
have time for, the next "right" thing to do is fork the upstream repo and
apply our changes there. But that introduces complications in that now we
have to apply any upstream patches to our own repo. Bleh. IMO lets just
keep it simple and either Forge-ify them or do a simple install or whatever
in the Profiles.