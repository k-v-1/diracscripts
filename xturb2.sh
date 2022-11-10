#/bin/bash
#
[[ $# -eq 0 ]] && eps=7.2500 || eps=$1
#printf '%b' "2.3741\n" "\n" "\n" "\n" "\n" "\n" "\n" "\n" "\n" "\n" "\n" "r all o\n" "r \"b\" b\n" "*\n" "\n" "\n" | cosmoprep
printf '%b' "$eps\n" "\n" "\n" "\n" "\n" "\n" "\n" "\n" "\n" "\n" "\n" "r all o\n" "r \"b\" b\n" "*\n" "\n" "\n" | cosmoprep
echo ""
echo $eps

