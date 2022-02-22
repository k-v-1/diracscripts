#!/bin/bash

names=()
for chk in "$@"; do
[[ "$chk" != *".chk" ]] && echo "Warning: file has no chk-extension? Continue in 5s" && sleep 5
names+=`pwd`/$chk
done
echo "${names[@]}"
exec /bin/sh -s <<EOF
for fl in "${names[@]}"; do
/usr/local/chem/g16A03/formchk \$fl
done
EOF
