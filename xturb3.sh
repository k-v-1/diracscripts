#/bin/bash
#

#first arg is mult: 1 or 3
#second arg is cosmo: x, 1 or 3
if [ $#  -lt 2 ]
then
   echo "Number of parameters supplied insufficient"
   echo "Syntax : multiplicity:1/3 cosmo: x/1/3"
   echo "so, first is states of interest, second is opt geom" #not sure this will work though if combi 1 and 3...
   return
fi

mult=$1
cosm=$2
indir=`pwd`

if grep -Fq "cosmo" $indir/control; then

if [ $cosm = "x" ]; then
sed -i '/rsolv/a\  cosmorel state=(x)       #GS\n\$cosmo_correlated' control
elif [ $cosm = 1 ]; then
sed -i '/rsolv/a\  cosmorel state=(a{1} 1)  #ES\n\$cosmo_correlated' control
elif [ $cosm = 3 ]; then
sed -i '/rsolv/a\  cosmorel state=(a{3} 1)  #ES\n\$cosmo_correlated' control
else
echo "second arg is cosmo: x, 1 or 3 --> take random if no cosmo"
return
fi

fi

sed -i "s/end/denconv - flag\n\$excitations\n  irrep=a  multiplicity=  $mult  nexc=  3  npre=  1  nstart=  1\n  exprop  states=all relaxed  operators=xdiplen,ydiplen,zdiplen\n  spectrum states=all  operators=xdiplen,ydiplen,zdiplen\n\$response\n  fop relaxed\n\$ricc2\n  adc(2)\n  maxiter = 100\n\$end/" control
