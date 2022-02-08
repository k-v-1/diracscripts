#/bin/bash
#
[[ $# -ne 0 ]] && charge=$1 || charge=0

sturb

x2t *.xyz > coord
printf '%b' "\n" "\n" "a coord\n" "*\n" "no\n" "b\n" "all def2-TZVP\n" "*\n" "eht\n" "\n" "$charge\n" "\n" "*\n" | define
sed -i 's/scfiterlimit       30/scfiterlimit       300/' control
sed -i 's/maxcor      500/maxcor      4000/' control


