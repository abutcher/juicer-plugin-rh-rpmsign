# -*- coding: utf-8 -*-
# juicer-plugin-rh-rpmsign - Red Hat Juicer RPM Signing Plugin
# Copyright © 2015, Red Hat, Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


import sys
import urlparse


class rhrpmsign:
    def __init__(self, item_type, environment, items):
        self.item_type = item_type
        self.environment = environment
        self.items = items

    def run(self):
        if self.item_type == 'rpm' and self.environment in ['stage','prod']:
            _path = '/usr/share/rpm-sign'
            if _path not in sys.path:
                sys.path.append(_path)
            import sig_client.client
            self.rpm_signer = sig_client.client.Runner()
            class Object(object):
                pass
            self.rpm_signer.options = Object()
            self.rpm_signer.options.principal = None
            self.rpm_signer.options.keytab = None
            (scheme, self.rpm_signer.netloc, self.rpm_signer.path, params, query, fragment) = \
                urlparse.urlparse(self.rpm_signer.server_url)
            self.rpm_signer.list_keys()
            self.rpm_signer.options.key = raw_input('\nwhich key would you like to use?\nkey: ')
            self.rpm_signer.args = map(lambda x: x.path, self.items)
            self.rpm_signer.sign_packages()
        else:
            return

