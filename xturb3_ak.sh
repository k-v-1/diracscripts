#/bin/bash
#
indir=`pwd`
[[ "$1" == "-ak" ]] && ak=True || ak=False

if [[ $#  -lt 2 ]]; then
    if [[ $# -lt 1 ]] || grep -Fq "cosmo" $indir/control; then
        #first arg is mult: 1 or 3
        #second arg is cosmo: x, 1 or 3
       echo "Number of parameters supplied insufficient"
       echo "Syntax : multiplicity:1/3 | mult of cosmostate: x/1/3 | es-num of cosmostate: 1/2/3/... (default=1 or 0 if \$2=x)"
       echo "(x is ground state)"
       echo "so, first is mp of interest, second is mp of opt geom, third is num of opt geom" #not sure this will work though if combi 1 and 3...
       echo "arg 2 and 3 only needed in case of cosmo"
       return
    fi
fi

mult=$1
cosm=$2
[[ $# -eq 3 ]] && esnum=$3 || esnum=1

if grep -Fq "cosmo" $indir/control; then

    if [[ "$cosm" == "x" ]]; then
        sed -i '/rsolv/a\  cosmorel state=(x)       #GS\n\$cosmo_correlated' control
    elif [[ "$cosm" -eq 1 ]]; then
        sed -i '/rsolv/a\  cosmorel state=(a{1} $esnum)  #ES\n\$cosmo_correlated' control
    elif [[ "$cosm" -eq 3 ]]; then
        sed -i '/rsolv/a\  cosmorel state=(a{3} $esnum)  #ES\n\$cosmo_correlated' control
    else
        echo "second arg is cosmo: x, 1 or 3 --> take random if no cosmo"
        return
    fi
    sed -i "s/end/denconv - flag\n\$excitations\n  irrep=a  multiplicity=  $mult  nexc=  3  npre=  1  nstart=  1\n  exprop  states=all relaxed  operators=xdiplen,ydiplen,zdiplen\n  spectrum states=all  operators=xdiplen,ydiplen,zdiplen\n  tmexc istates=all fstates=all operators=xdiplen,ydiplen,zdiplen\n\$response\n  fop relaxed\n\$ricc2\n  adc(2)\n  maxiter = 100\n\$end/" control
    return
else:
    sed -i "s/end/denconv - flag\n\$excitations\n  irrep=a  multiplicity=  $mult  nexc=  3  npre=  1  nstart=  1n  spectrum states=all  operators=xdiplen,ydiplen,zdiplen\n\$response\n  tmexc istates=all fstates=all operators=xdiplen,ydiplen,zdiplen\n\$ricc2\n  adc(2)\n  maxiter = 100\n\$end/" control

fi

if [[ "$ak" == "False" ]]; then
    sed -i 's/tmexc istates=all fstates=all operators=xdiplen,ydiplen,zdiplen//' control
fi

