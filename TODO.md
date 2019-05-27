To Do
=====

Scratchpad for random ideas of things that need done.

* Deal with any server warnings
* Linux support for a whole buncha stuff for profile::cfcc::camper
* Refactor role::base and role::camper to deal with site at the root.
* Figure out $::kernel (Linux) vs $::operatingsystem (Linux) vs $::osfamily (RedHat)
* Update all modules
* windows features (cant use module because it only supported server. maybe clone?) .NET Framework 3.5
* Bonjour package via choco takes two to successfully install
* restoring open programs on reboot
* Restructure mdns into profile::mdns::client with subs of bonjour, avahi, etc
* Why did Zotac8 have a USB E drive that didn't exist?

Mac
* Autologin
* quake shortcut (any shortcut, need alias)
* web sharing?

Linux
* autologin
* virtualbox extension
* firewall
* profile::python::turtle
* profile::ide::scratch
* profile::java::jdk

Infrastructure
--------------

### Metrics & Logging
* https://logz.io/blog/monitoring-dockerized-elk-stack/
* http://docs.grafana.org/features/datasources/elasticsearch/
* https://www.elastic.co/guide/en/logstash/current/plugins-filters-metrics.html

### Caching
* Sonatype Nexus (Yum and Choco)

Bolt
----
* https://forge.puppet.com/nekototori/winrmssl/readme
* https://puppet.com/docs/bolt/0.x/bolt_installing.html#ariaid-title2

Firmware Issues
---------------
* 22.21.13.8205 - 1070K fails err 43 (only on old BIOS?)
* 390.77 worked as of 2018-01-23
* 430.64 5-5-2019 26.21.14.3064

Z8: B333P115 11/06/2017
Z9/Z10: B333P117 03/21/2018 (this one didnt have the crap resolution with Windows Update)
Z2: B333P 0.09 x64 11/08/2016
Z5: B336P111 08/14/2017

BIOS Settings
-------------
Main
* Project Version
* Build Date
Boot
* Boot Mode
* Storage
* Video