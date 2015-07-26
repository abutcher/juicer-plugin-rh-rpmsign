#!/usr/bin/make

# Disable implicit rules
.SUFFIXES:

########################################################

# Makefile for juicer-plugin-rh-rpmsign
#
# useful targets:
#   make sdist ---------------- produce a tarball
#   make rpm  ----------------- produce RPMs

########################################################

# > VARIABLE = value
#
# Normal setting of a variable - values within it are recursively
# expanded when the variable is USED, not when it's declared.
#
# > VARIABLE := value
#
# Setting of a variable with simple expansion of the values inside -
# values within it are expanded at DECLARATION time.

########################################################

# variable section
NAME := juicer-plugin-rh-rpmsign

VERSION := $(shell cat VERSION)

# RPM build parameters.
RPMSPECDIR := .
RPMSPEC := $(RPMSPECDIR)/juicer-plugin-rh-rpmsign.spec
RPMVERSION := $(VERSION)
RPMRELEASE = $(shell awk '/Release/{print $$2; exit}' < $(RPMSPEC).in | cut -d "%" -f1)
RPMDIST = $(shell rpm --eval '%dist')
RPMNVR = $(NAME)-$(RPMVERSION)-$(RPMRELEASE)$(RPMDIST)

########################################################

all: rpm

clean:
	@echo "Cleaning up distutils stuff"
	@rm -rf build dist
	@echo "Cleaning up editor backup files"
	@find . -type f \( -name "*~" -or -name "#*" \) -delete
	@find . -type f \( -name "*.swp" \) -delete
	@echo "Cleaning up RPM building stuff"
	@rm -rf rpm-build

sdist: clean
	mkdir dist
	cd dist && cp -r ../juicer-plugin-rh-rpmsign ./juicer-plugin-rh-rpmsign-$(VERSION)
	cd dist && tar czf $(NAME)-$(VERSION).tar.gz juicer-plugin-rh-rpmsign-$(VERSION)

rpmcommon: sdist
	@mkdir -p rpm-build
	@cp dist/*.gz rpm-build/

srpm: rpmcommon
	@rpmbuild --define "_topdir %(pwd)/rpm-build" \
	--define "_builddir %{_topdir}" \
	--define "_rpmdir %{_topdir}" \
	--define "_srcrpmdir %{_topdir}" \
	--define "_specdir $(RPMSPECDIR)" \
	--define "_sourcedir %{_topdir}" \
	-bs $(RPMSPEC)
	@echo "#############################################"
	@echo "juicer-plugin-rh-rpmsign SRPM is built:"
	@echo "    rpm-build/$(RPMNVR).src.rpm"
	@echo "#############################################"

rpm: rpmcommon
	@rpmbuild --define "_topdir %(pwd)/rpm-build" \
	--define "_builddir %{_topdir}" \
	--define "_rpmdir %{_topdir}" \
	--define "_srcrpmdir %{_topdir}" \
	--define "_specdir $(RPMSPECDIR)" \
	--define "_sourcedir %{_topdir}" \
	-ba $(RPMSPEC)
	@echo "#############################################"
	@echo "juicer-plugin-rh-rpmsign RPM is built:"
	@echo "    rpm-build/noarch/$(RPMNVR).noarch.rpm"
	@echo "#############################################"

rpminstall: rpm
	-rpm -e juicer-plugin-rh-rpmsign
	rpm -Uvh rpm-build/noarch/$(RPMNVR).noarch.rpm
