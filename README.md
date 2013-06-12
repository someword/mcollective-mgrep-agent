Mgrep Agent Plugin
=============================
The mgrep agent remotely executes `grep` with a limited set of supported command line switches.  

Installation
=============================

  * Follow the [basic plugin install guide](http://projects.puppetlabs.com/projects/mcollective-plugins/wiki/InstalingPlugins) by placing 
 agent/mgrep.rb and agent/auditlogger.ddl in the agent directory.  The file application/mgrep.rb should be put in the application directory. 

  * You can also use 'mco plugin package' to build packages to be installed on your servers and clients.
  mco plugin package mcollective-mgrep-agent

Configuration
=============================
By default you don't need to do any configuration to use the mgrep agent.   You can deploy a plugin config file called `mgrep.cfg` which contains a list of files or directory paths which you do not want searched.    The format of the `mgrep.cfg` file is one file path per line.  For example you might have something like this in your file.

/etc/shadow
/etc/kfc
.gnupg

With the above blacklist the following files could not be grepped

/etc/shadow
/etc/kfc/recipes/original.recipe
/root/.gnupg

Usage
=============================

Find the `nameserver` entries in /etc/resolv.conf
mco mgrep -f /etc/resolv.conf -p nameserver

Find the `baseurl` for any file matching /etc/yum.repos.d/*.  Notice that if you don't single quote the splat it won't get passed through correctly.
mco mgrep -f '/etc/yum.repos.d/*' -p baseurl

Search a blacklisted file
mco mgrep -f /etc/shadow -p root
---- output for somenode.yo ---->
Blacklisted file(s): /etc/shadow

Ignore case on a search
mco mgrep -f /etc/puppet/puppet.conf -p ssl -i

Invert the match
mco mgrep -f /etc/puppet/puppet.conf -p ssl -i -V

