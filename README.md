TurboPuppet
======
Monolithic Puppet repo for [Camp Fitch Tech Focus](http://campcomputer.com). The code here may
someday be used to do automatic camper PC deployment and more!

Supported Platforms
-------------------
* Clients: Windows 10, Fedora 28\*, MacOS\*
* Servers: CentOS 7

\*=Not fully or even partially baked

Organization
------------

### Roles
A role is a single "this is a X computer" purpose. A PC should have 
no more than one role. Roles should not include other roles. Some examples:

* ```role::camper::web```
* ```role::camper::java```
* ```role::camper::pyle```

An example role:
```puppet
class role::camper::java inherits role::camper {
    include profile::java::jdk8
    include profile::ide::intellij

    Class['profile::java::jdk8'] -> Class['profile::ide::intellij']
}
```
This role defines the tools that are needed for that role and some class ordering.

Every camper role needs to inherit from ```role::camper``` as this includes
the common stuff to every role, operating-system defaults, and the big three below. 
Roles are made up of profiles described below.

#### "The Big Three"
Every role should include a minimum of three things:
1) Site class (ex: ```site::cfcc```)
2) Device class (ex: ```profile::cfcc::camper```)
3) Access profile (ex: ```profile::access::camper```)

These are the basic building blocks of a role. Everything else comes afterward. These
are defined for camper roles in the ```role::camper``` class.

### Profiles
Profiles are a single logical unit for a feature. Profiles can include
or depend on other profiles. Examples include:

* ```profile::browser::chrome```
* ```profile::ide::pycharm```
* ```profile::game::starcraft```

Normally profiles cobble together modules and misc other manifest-y stuff
to complete a feature. But since most of the modules out there don't
support Windows we're gonna need to put that logic in the profiles.

In general a common profile looks like this:
```puppet
class profile::category::feature {
    case $::operatingsystem {
        'windows': {
            include profile::category::feature::windows
        }
        default: { }
    }
    
    package_name = $::operatingsystem ? {
        'windows' => 'feature-win',
        'fedora' => 'feature-fc27',
        default   => fail('Unsupported OS')
    }
    
    package { $package_name: }
}
```
Some notes on this example:
1) Platform-specific addons, shortcuts, and other tweaks should go
in a subclass (shown here as ```profile::category::feature::windows```).
2) You can set a variable by case if it's different per-platform.
3) The default ```ensure``` for the ```package {}``` resource is set with those
other OS-defaults mentioned in Roles. You could specify all that stuff here,
but this saves some time.

### Sites
There is a semantic difference between what Puppet considers a site
(and thus a ```site.pp``` file) and what we logically consider a site
(place in the world). In our case here, a site class defines settings
 that are unique to a particular installation. You never know, someday
 this stuff may be useful in another camp setting. The ```site.pp``` file
 is used by Puppet as a starting point for functions and things that should
 be available to LITERALLY everything. This is used sparingly.
 
An example of the former (and more relevant) usage of the word Site:
```puppet
class site::cfcc {
    $puppet_master = 'puppet.campcomputer.com'
}
```

These sites are then loaded into a generic ```turbosite``` class which can
then be referenced in the profiles. Since there could be multiple sites
it would be inappropriate to statically reference say ```site::cfcc::puppet_master```.

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

We do keep one single module here (the `cfcc` module). It's too small
to be it's own repo right now so I'll deal with it later.

### File Serving
Seeing as referencing files on a NAS is a pain between OS's, a custom Puppet 
HTTP file server is configured in ```fileserver.conf```. This is referenced as
```puppet:///campfs/${FILENAME}``` in the code. It's actually a mount on the
Puppetmaster to an underlying NAS share, but could be anything as long as
the files are there. Warning! This is not the same as the `cfcc` module above.
