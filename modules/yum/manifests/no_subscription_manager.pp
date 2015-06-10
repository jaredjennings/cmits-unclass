# % CMITS - Configuration Management for Information Technology Systems
# % Based on <https://github.com/afseo/cmits>.
# % Copyright 2015 Jared Jennings <mailto:jjennings@fastmail.fm>.
# %
# % Licensed under the Apache License, Version 2.0 (the "License");
# % you may not use this file except in compliance with the License.
# % You may obtain a copy of the License at
# %
# %    http://www.apache.org/licenses/LICENSE-2.0
# %
# % Unless required by applicable law or agreed to in writing, software
# % distributed under the License is distributed on an "AS IS" BASIS,
# % WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# % See the License for the specific language governing permissions and
# % limitations under the License.
# \subsection{Turn off the Subscription Manager}
#
# Red Hat has moved to certificate-based subscriptions, using the Subscription
# Manager. But RHN Satellite 5.4.1 does not use these. But the plugin for
# certificate-based management is enabled by default. So since we don't have
# the certificates, every time Yum runs, that plugin complains that this system
# isn't subscribed. This class fixes that.

class yum::no_subscription_manager {
    augeas { 'disable_subscription_manager':
        context => "/files/etc/yum/pluginconf.d/\
subscription-manager.conf",
        changes => "set main/enabled 0",
    }
}
        
