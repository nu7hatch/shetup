#!/bin/bash -e

rm -rf /tmp/*-shetup-*
out=/tmp/shetup.tar.gz
wget -O $out https://github.com/nu7hatch/shetup/tarball/master
tar -xzf $out -C /tmp
cp -rf /tmp/*-shetup-*/src ./setup

cat > ./setup.sh <<EOF
#!/bin/bash

. ./setup/core.bash

check_cmd test

success "Package has been successfully configured. Check README.md for more details!"
EOF

chmod +x ./setup.sh
