#!/bin/bash

queue=$1
indir=`pwd`
name=`basename $indir`

if grep -Fq "cosmo" $indir/control; then
smpser="ser"
else
smpser="smp"
fi


cat <<END > dsc.job
. /usr/local/chem/turbomole7.1/vars.$smpser

cd /temp0/`whoami`
cat > rmfile
rm *

cp $indir/* .
dscf > dscf.out

cp * $indir
END

qsub -q $queue dsc.job -N $name
