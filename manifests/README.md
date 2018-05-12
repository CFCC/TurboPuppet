Manifest Organization
=====================

Roles
-----
### role::base
Sets up all Puppet resources for a given operating system. Examples:
* Powershell
* Chocolatey

### role::camper::topic
A specific purpose for a camper machine.
* Site
* Master Profile
* Access
* Topic tools

Profiles
--------
### profile::cfcc::camper
Master profile for a particular role.
* OS customizations
* Software repos
* System tools
* Common software

Sites
----- 
### site::cfcc
Settings specifically for the Camp Fitch Tech Focus lab.