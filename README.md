TurboPuppet
======
Monolithic Puppet repo for [Camp Fitch Tech Focus](http://campcomputer.com). The code here may someday be used to do automatic camper PC deployment and more!

Supported Platforms
-------------------
* Clients: Windows 11, Fedora 34\*, MacOS\*

\*=Not fully or even partially baked, especially with TurboPuppet

Organization
------------

### Roles
A role is a single "this is a X computer" purpose. A PC should have no more than one role. Roles should not include other roles. Some examples:

* ```roles::camper::web```
* ```roles::camper::java```
* ```roles::camper::pyle```

An example role:
```puppet
class roles::camper::java inherits roles::camper {
    include profiles::java::jdk8
    include profiles::ide::intellij

    Class['profiles::java::jdk8'] -> Class['profiles::ide::intellij']
}
```
This role defines the tools that are needed for that role and some class ordering.

Every camper role needs to inherit from `roles::camper` as this includes the common stuff to every role, operating-system defaults, and the big three below. Roles are made up of profiles described below.

#### "The Big Ones"
Every role should include a minimum of two things:
1) Device class (ex: `profiles::cfcc::camper`)
2) Access profile (ex: `profiles::access::camper`)

These are the basic building blocks of a role. Everything else comes afterward. These are defined for camper roles in the `roles::camper` class.

### Profiles
Profiles are a single logical unit for a feature. Profiles can include or depend on other profiles. Examples include:

* `profiles::browser::chrome`
* `profiles::ide::pycharm`
* `profiles::game::starcraft`

Normally profiles cobble together modules and misc other manifest-y stuff to complete a feature. But since most of the modules out there don't support Windows we're gonna need to put that logic in the profiles.

In general a common profile looks like this:
```puppet
class profiles::category::feature {
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
1) Platform-specific addons, shortcuts, and other tweaks should go in a subclass (shown here as `profile::category::feature::windows`).
2) You can set a variable by case if it's different per-platform.
3) The default `ensure` for the `package {}` resource is set with those other OS-defaults mentioned in Roles. You could specify all that stuff here, but this saves some time.

### Hiera Values
TODO this

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
TODO: document the new lookup pattern