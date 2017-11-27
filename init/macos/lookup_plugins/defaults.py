#
# Ansible lookup plugin for traversing OSX defaults structured as follows:
# 
# defaults:
#   <domain>:
#   - <key>: { <type>: <value> }
#

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

from ansible.errors import AnsibleError
from ansible.plugins.lookup import LookupBase
from ansible.utils.listify import listify_lookup_plugin_terms

class LookupModule(LookupBase):

    def run(self, terms, variables=None, **kwargs):
        if not isinstance(terms, dict):
            raise AnsibleError("parameter to 'defaults' should be a dictionary and not a '" + type(defaults).__name__ + "'")

        results = []

        for (d, keys) in terms.iteritems():
            if not isinstance(keys, list):
                raise AnsibleError("Domain '" + d + "' should contain a list of keys '- <key>: {<type>:<value>}'")
            for key in keys:
                if not isinstance(key, dict):
                    raise AnsibleError("Key '" + str(key) + "' should be a dict '<key>: {<type>:<value>}'")
                if len(key) != 1:
                    raise AnsibleError("Key dict '" + str(key) + "' should contain a single entry")

                for (k, tv) in key.iteritems():
                    if not isinstance(tv, dict):
                        raise AnsibleError("Key '" + k + "' in domain '" + d + "' should contain a dict '{<type>:<value>}'")
                    if len(tv) != 1:
                        raise AnsibleError("Key '" + k + "' in domain '" + d + "' should reference a single-entry dict")
                    for (t, v) in tv.iteritems():
                        if t not in ['bool','int','float','string']:
                            raise AnsibleError("Non-supported type '" + t + "' of key '" + k + "' in domain '" + d + "'")
                        results.append({'domain': d,'key': k,'type': t,'value': v })

        return results

