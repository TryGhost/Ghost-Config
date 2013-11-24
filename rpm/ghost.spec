Name:           ghost
Version:        %{_ver}
Release:        3%{?dist}
Summary:        Ghost is a free, open, simple blogging platform

Group:          Application/Internet 
License:        MIT
URL:            http://ghost.org/
Source0:        http://ghost.org/zip/ghost-%{version}.zip
Source1:	ghost.init
Source2:	ghost.logrotate
Source3:	ghost.sysconfig
Source4:	ghost.config.js

BuildRequires:   nodejs >= 0.10.0 npm rsync
Requires:        nodejs >= 0.10.0 daemonize
Requires(post):  chkconfig
Requires(preun): chkconfig
Requires(preun): initscripts
Requires(postun): initscripts

%global installroot %{_datarootdir}/%{name}
%global username %{name}

%description
Ghost is an Open Source application which allows you to write and publish your
own blog, giving you the tools to make it easy and even fun to do. It's simple,
elegant, and designed so that you can spend less time making your blog work
and more time blogging.

%prep
%setup -c

%build
npm install --production

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT%{installroot} \
  $RPM_BUILD_ROOT%{_sharedstatedir}/%{name}/ \
  $RPM_BUILD_ROOT%{_localstatedir}/log/%{name}/ \
  $RPM_BUILD_ROOT%{_defaultdocdir}/%{name}/
cp -r core content node_modules $RPM_BUILD_ROOT%{installroot}/
install -m 0644 package.json index.js config.example.js $RPM_BUILD_ROOT%{installroot}
install -m 0640 %{_sourcedir}/ghost.config.js $RPM_BUILD_ROOT%{installroot}/config.js
install -m 0644 -D *.md LICENSE.txt $RPM_BUILD_ROOT%{_defaultdocdir}/%{name}/
install -D %{_sourcedir}/ghost.init $RPM_BUILD_ROOT%{_sysconfdir}/init.d/ghost
install -m 0644 -D %{_sourcedir}/ghost.logrotate \
  $RPM_BUILD_ROOT%{_sysconfdir}/logrotate.d/ghost
install -m 0644 -D %{_sourcedir}/ghost.sysconfig \
  $RPM_BUILD_ROOT%{_sysconfdir}/sysconfig/ghost
ln -s %{installroot}/config.js $RPM_BUILD_ROOT/%{_sysconfdir}/ghost.conf
touch $RPM_BUILD_ROOT%{_localstatedir}/log/%{name}/standard.log
touch $RPM_BUILD_ROOT%{_localstatedir}/log/%{name}/error.log


%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%dir %{installroot}
%{installroot}/index.js
%{installroot}/package.json
%{installroot}/config.example.js
%{installroot}/core
%{installroot}/node_modules
%dir %{installroot}/content/
%attr(0755,%{username},%{username}) %{installroot}/content/*
%attr(0750,%{username},%{username}) %dir %{_sharedstatedir}/ghost
%dir %{_defaultdocdir}/%{name}
%doc %{_defaultdocdir}/%{name}/*
%{_sysconfdir}/init.d/ghost
%{_sysconfdir}/logrotate.d/ghost
%attr(0640,root,%{username}) %config(noreplace) %{installroot}/config.js
%{_sysconfdir}/ghost.conf
%config(noreplace) %{_sysconfdir}/sysconfig/ghost
%attr(0750,%{username},%{username}) %dir %{_localstatedir}/log/ghost
%attr(0640,%{username},%{username}) %config %ghost %{_localstatedir}/log/ghost/standard.log
%attr(0640,%{username},%{username}) %config %ghost %{_localstatedir}/log/ghost/error.log


%pre
getent group %{username} >/dev/null || groupadd -r %{username}
getent passwd %{username} >/dev/null || \
  useradd -r -g %{username} -d %{_prefix} -s /bin/false \
  -c "%{name} user" %{username}
exit 0

%post
/sbin/chkconfig --add %{name}

%preun
if [ "$1" -eq "0" ] ; then
    /sbin/service ghost stop >/dev/null 2>&1
    /sbin/chkconfig --del %{name}
fi

%postun
if [ "$1" -ge "1" ] ; then
   /sbin/service %{name} condrestart >/dev/null 2>&1 || true
fi

%changelog
* Sun Nov 10 2013 Matt Willsher <matt@monki.org.uk>
- Include logs as ghost entries
- Remove supervisor dependency

* Fri Nov 08 2013 Matt Willsher <matt@monki.org.uk> 
- Initial packaging
