%define version          1.0.0
%define release          0
%define sourcename       check_letsdebug
%define packagename      nagios-plugins-check_letsdebug
%define nagiospluginsdir %{_libdir}/nagios/plugins

# No binaries in this package
%define debug_package %{nil}

Summary:   A Nagios plugin to check X.509 certificates
Name:      %{packagename}
Version:   %{version}
Obsoletes: check_letsdebug
Release:   %{release}%{?dist}
License:   GPLv3+
Packager:  Matteo Corti <matteo@corti.li>
Group:     Applications/System
BuildRoot: %{_tmppath}/%{packagename}-%{version}-%{release}-root-%(%{__id_u} -n)
URL:       https://github.com/matteocorti/check_letsdebug
Source:    https://github.com/matteocorti/check_letsdebug/releases/download/v%{version}/check_letsdebug-%{version}.tar.gz

Requires:  nagios-plugins expect perl(Date::Parse)

%description
A shell script (that can be used as a Nagios plugin) to check an SSL/TLS connection

%prep
%setup -q -n %{sourcename}-%{version}

%build

%install
make DESTDIR=${RPM_BUILD_ROOT}%{nagiospluginsdir} MANDIR=${RPM_BUILD_ROOT}%{_mandir} install

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc AUTHORS ChangeLog NEWS README.md COPYING VERSION COPYRIGHT
%attr(0755, root, root) %{nagiospluginsdir}/check_letsdebug
%{_mandir}/man1/%{sourcename}.1*

%changelog
* Wed Jun  23 2021 Matteo Corti <matteo@corti.li> - 1.0.0-0
- Initial release
