#If you need to have postgresql@15 first in your PATH
export PATH="/usr/local/opt/postgresql@15/bin:$PATH"

# For compilers to find postgresql@15
export LDFLAGS="-L/usr/local/opt/postgresql@15/lib"
export CPPFLAGS="-I/usr/local/opt/postgresql@15/include"

# For pkg-config to find postgresql@15
export PKG_CONFIG_PATH="/usr/local/opt/postgresql@15/lib/pkgconfig:$PKG_CONFIG_PATH"
