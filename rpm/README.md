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

This is the prefered method of building the RPM packages.

* Install CentOS 6.4
* Install [EPEL](http://fedoraproject.org/wiki/EPEL) access from [RPM](http://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/epel/6/i386/repoview/epel-release.html)
* Install the build tools
```sh
sudo yum install rpmdevtools rpm-build mock yum-utils git gpg
```
* Add your user to the mock group
```
sudo usermod -a -G mock $( whoami )
```
* Checkout this repository
* To build the latest version run
```sh
./build_ghost_rpm
```
To build a specific release of ghost, append it to the call, e.g.
```sh
./build_ghost_rpm 0.3.2
```
* The packages will be in the ```yum/``` directory

#### Usage

<!--- START of usage -->

  build_ghost_rpm [-r epel_root] [-a rpm_arch] [-o yum_path] [ghost_release_number]

    Command line options override environmental variables.
 
    release_number  The release number of Ghost to package.

    -s              Build the SRPM only

    -r epel_root    Use the given epel root to build the RPM. See the contents
                    of /etc/mock. Defaults to epel-6-x86_64.

    -a rpm_arch     Build against an architecture other then the epel_root's
                    default. Defaults to the target_arch of the epel_root.

    -o yum_path     Root directory of the yum repository to put resulting RPMs.
                    Defaults to yum in the same directory as the build_ghost_rpm
                    script.

    Environmental Variables

    GHOST_RPM_GPG_PASSPHRASE  Passphrase for gpg signing key. %_gpg_name and
                              %_signature need to be set in ~/.rpmmacros

    GHOST_MOCK_VERBOSITY      Either '' or '--verbose' to increase mock output

    GHOST_MOCK_ROOT           As -r, above.

    GHOST_RELEASE_NUMBER      As release_number, above.

    GHOST_YUM_PATH            As -o, above.

    GHOST_RPM_ARCH            As -a, above.

    GHOST_RPM_SPEC            Ghost RPM spec file to use. Defaults to
                              ghost.spec in the same directory as this script

    GHOST_RPM_SOURCES         Directory contain the sources used by the spec
                              file. Defaults to sources in the same directory
                              as this script

<!--- END of usage -->

### Signing the packages

If the environmental variable ``GHOST_RPM_GPG_PASSPHRASE``` is set, the
build_ghost_rpm script will sign the RPMs, both source and binary, it produces.

For this to work, ~/.rpmmacros needs to exist with %_gpg_name set to the name
of the signing key, and %_signature to gpg. To sign all the package after
build, set GHOST_RPM_GPG_PASSPHRASE to the gpg key passphrase and export the
variable then run:

```sh
find yum/ -name *.rpm -exec ./rpmsign-batch.expect {} \;
```
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
