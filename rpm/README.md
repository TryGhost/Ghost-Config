RPM packaging
=============

**Beware** The contents of this tree is still under going testing.

The contents of this tree create a self contained RPM file of the
[Ghost](http://ghost.org) blog software. It is designed to be built
using mock, though direct rpmbuild calls will work too.

Building the package
--------------------

To work around wget not recognising the alternative DNS name in the
ghost.org SSL certificate, add the following to ```$HOME/.wgetrc```. There is an [issue open](https://github.com/TryGhost/Ghost-Config/issues/2) for this. Once fixed this step won't be required.
```
check-certificate=off
```

### Using mock

This is the prefered method of building RPM packages.

* Install CentOS 6.4
* Install [EPEL](http://fedoraproject.org/wiki/EPEL) access from [RPM](http://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/epel/6/i386/repoview/epel-release.html)
* Install the build tools
```sh
sudo yum install rpmdevtools rpm-build mock yum-utils git
```
* Add your user to the mock group
```
sudo usermod -a -G mock $( whoami )
```
* Checkout this repository
* To build the latest version run
```sh
./build
```
To build a specific version append it to the build.sh call, e.g.
```sh
./build 0.3.2
```
* The packages will be in the ```RPM/``` directory

### Using rpmbuild

To use rpmbuild rather than mock, install EPEL as above. Create a file
called $HOME/.rpmmacros containing the following and set %_topdir to where-ever
you have the rpm folder

```
%_topdir      %(echo $HOME)/Ghost-Config/rpm
%_smp_mflags  -j3
%__arch_install_post   /usr/lib/rpm/check-rpaths   /usr/lib/rpm/check-buildroot
```

cd to your topdir and install build dependencies with the following, replacing 0.3.3 with the version of Ghost you wish to build
```
sudo yum-builddep SPECS/ghost.spec
spectool -g -C SOURCES -d '_ver 0.3.3' SPECS/ghost.spec
```
Now build the packages with the following, again replacing 0.3.3 with the version required
```
rpmbuild -D '_ver 0.3.3' -ba SPECS/ghost.spec
```

The built RPM file will be in RPMS/$arch/ where arch is your system's architecture - x86_64, i686 etc.

Installing the package
----------------------

EPEL is needed, as per the build steps above. Once that's installed run:
```sh
sudo yum install ghost-0.3.3-1.el6.x86_64.rpm
```
The application gets installed in /opt/ghost.
Configure ghost to your needs by editing /etc/ghost.conf and then
run ```sudo service ghost start``` to start up. Once you're happy it's running as you way, run ```sudo chkconfig ghost on``` to start at boot time

Upgrading the package
---------------------

During package upgrade, if Ghost is running it will be stopped and started, launching the new version of the software.
