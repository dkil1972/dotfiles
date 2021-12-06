if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

if [ -f ~/.localrc ]; then
  . ~/.localrc
fi

# Setting PATH for Python 2.7
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH

source ~/.profile

export PATH=$PATH:/Users/dermot/bin

source '/Users/dermot/lib/azure-cli/az.completion'

##
# Your previous /Users/dermot/.bash_profile file was backed up as /Users/dermot/.bash_profile.macports-saved_2020-10-04_at_18:54:58
##

# MacPorts Installer addition on 2020-10-04_at_18:54:58: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

