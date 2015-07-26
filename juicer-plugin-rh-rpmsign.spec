%if 0%{?rhel} <= 5
%{!?python_sitelib: %global python_sitelib %(%{__python} -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")}
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
%endif

Name: juicer-plugin-rh-rpmsign
Release: 1%{?dist}
Summary: Red Hat Juicer RPM Signing Plugin
Version: 0.0.1

Group: Development/Libraries
License: Private
Source0: %{name}-%{version}.tar.gz
Url: https://github.com/abutcher/juicer-plugin-rh-rpmsign

BuildArch: noarch

Requires: juicer >= 1.0.0-1
Requires: rpm-sign


%description 
Red Hat Juicer RPM signing plugin which reaches out to sign RPMs as
part of juicer.

%prep
%setup -q

%build
cp -v rhrpmsign.py $RPM_BUILD_ROOT

%install
mkdir -p $RPM_BUILD_ROOT/%{_datadir}/juicer/plugins/pre/
cp -v rhrpmsign.py $RPM_BUILD_ROOT/%{_datadir}/juicer/plugins/pre/

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%{_datadir}/juicer*

%changelog
* Sun Jul 26 2015 Andrew Butcher <abutcher@redhat.com> - 0.0.1-1
- Initial.

