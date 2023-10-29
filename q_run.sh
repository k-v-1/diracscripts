#!/bin/bash
if [[ "$1" == "-h" || "$1" == "--help" || $# -eq 0 ]]; then
    echo '$1 -> input.com [optional $2 -> queue]'
    exit 0
fi
inp=`pwd`/$1
inpdir=`pwd`
queue=$2
out=${inp%.com}.out
name=`whoami`
inpnm=`basename $inp`
tmpdir=${inpnm%.com}
if [[ "x" == "x$queue" ]]; then
  queue=`/home/koen/.scrpts/qsmk2.sh | grep "Free" | awk '{print $2}'`
fi                                                                        
echo $queue                                                             
cat <<END > $inpnm.job
NN=(\$(cat \$PBS_NODEFILE|wc -l))
export QC=/usr/local/chem/qchem-5.4
export QCSCRATCH=/temp0/$name
export QCAUX=\$QC/qcaux
#export PATH=\$QC/exe/:\$PATH
#export LD_LIBRARY_PATH=/usr/local/gcc-10.2.0/lib64/
export PATH=\$PATH:\$QC/bin
export LD_LIBRARY_PATH=/usr/local/gcc-10.3.0/lib64:/usr/local/OpenBLAS-0.3.20/lib
. \$QC/bin/qchem.setup.sh
. \$QC/bin/qchem.setup.sh.rel

#. \$QC/qcenv.sh
mkdir -p \$QCSCRATCH/$tmpdir
#if tmpdir exist:rm *
\$QC/bin/qchem -nt \$NN $inp $out $tmpdir
cp $inpnm.fchk $inpdir
END
qsub -q $queue $inpnm.job -N $inpnm

