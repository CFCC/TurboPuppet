TurboPuppet
======
Monolithic Puppet repo for [Camp Fitch Tech Focus](http://campcomputer.com). The code here may
someday be used to do automatic camper PC deployment and more!

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
class role::camper::java inherits role::base {
    include site::cfcc
    include profile::cfcc::camper
    include profile::access::camper

    include profile::java::jdk8
    include profile::ide::intellij

    Class['site::cfcc'] -> Class['profile::cfcc::camper']
    Class['site::cfcc'] -> Class['profile::access::camper']
    Class['profile::java::jdk8'] -> Class['profile::ide::intellij']
}
```
This role defines the tools that are needed for that role and some class ordering.

Every role needs to inherit from ```role::base ``` as this includes
the common stuff to every role and operating-system defaults. Roles are made up 
of profiles described below.

#### "The Big Three"
Every role should include a minimum of three things:
1) Site class (ex: ```site::cfcc```)
2) Device class (ex: ```profile::cfcc::camper```)
3) Access profile (ex: ```profile::access::camper```)

These are the basic building blocks of a role. Everything else comes afterward.

### Profiles
Profiles are a single logical unit for a feature. Profiles can include
or depend on other profiles. Examples include:

* ```profile::browsers::chrome```
* ```profile::ide::pycharm```
* ```profile::games::starcraft```

Normally profiles cobble together modules and misc other manifest-y stuff
to complete a feature. But since most of the modules out there don't
support Windows we're gonna need to put that logic in the profiles.

In general a common profile looks like this:
```puppet
class profile::category::feature {
    case $::osfamily {
        'windows': {
            include profile::category::feature::windows
        }
        default: { }
    }
    
    package_name = $::osfamily ? {
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
    $nas_host = 'CFCCFS01'
    $nas_share = 'Public'
    $puppet_master = 'puppet.campcomputer.com'
}
```

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

We do keep one single module here (the cfcc module). It's too small
to be it's own repo right now so I'll deal with it later.

To update:
```shell
sudo docker exec -it puppet bash -c 'cd /etc/puppetlabs/code/environments/production && r10k puppetfile install -v'
```
