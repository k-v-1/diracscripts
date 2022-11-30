#/bin/bash
#
deut=False
[[ $# -ne 0 ]] && charge=$1 || charge=0
[[ $# -eq 2 ]] && [[ "$2" == "-D" ]] && deut=True

. /usr/local/chem/turbomole7.1/vars.smp

x2t *.xyz > coord
if [[ "$deut" == True ]]; then
printf '%b' "\n" "\n" "a coord\n" "*\n" "no\n" "b\n" "all def2-TZVP\n" "m\n" "\"h\" 2.0141\n" "*\n" "eht\n" "\n" "$charge\n" "\n" "*\n" | define
else
printf '%b' "\n" "\n" "a coord\n" "*\n" "no\n" "b\n" "all def2-TZVP\n" "*\n" "eht\n" "\n" "$charge\n" "\n" "*\n" | define
fi
sed -i 's/scfiterlimit       30/scfiterlimit       300/' control
sed -i 's/maxcor      500/maxcor      4000/' control


