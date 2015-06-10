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
# \subsection{Hot corners}
#
# Configure ``hot corners'' on Macs, that is, actions that happen when the
# mouse pointer is moved to a corner of the screen and left there for a couple
# of seconds.
#
# The \verb!hot_corner! resource defined below makes a computer-wide policy for
# what action should be attached to one of the corners of the screen.
#
# The name of a \verb!hot_corner! resource is one of the four strings
# \verb!tl!, \verb!tr!, \verb!bl! or \verb!br!, denoting which corner of the
# screen we're talking about.
# \verb!action! is one of the keys in the settings hash below.
#
# Example:
# \begin{verbatim}
#   hot_corner { 'tl':
# \end{verbatim}
# \dinkus

define hot_corner($action) {


# These settings were derived under Snow Leopard by changing the settings in
# System Preferences, and reading them out using \verb!defaults(1)!.
    $settings = {
        'nothing'             => 1,
        'all-windows'         => 2,
        'application-windows' => 3,
        'desktop'             => 4,
        'dashboard'           => 7,
        'spaces'              => 8,
        'start-screensaver'   => 5,
# Don't configure any of the corners to disable the screensaver. Don't.
 #          'disable-screensaver' => 6,
        'sleep-display'       => 10,
    }

    mcx::set { "com.apple.dock/wvous-${name}-corner":
        value => $settings[$action],
    }

# Not sure exactly what the modifier means; this is just what showed up in the
# \verb!defaults(1)! when a corner was set to no action.
    mcx::set { "com.apple.dock/wvous-${name}-modifier":
        value => $action ? {
            'nothing' => 1048576,
            default   => 0,
        },
    }
}

