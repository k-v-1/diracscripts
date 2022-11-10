#!/bin/bash

resflag=0
OPTIND=1
while getopts "r" opt; do
  case $opt in
    r) resflag=1
       echo "restart == $resflag";;
  esac
done
shift $((OPTIND-1))
[[ $# -lt 2 ]] && echo "not enough args" && exit 1
indir=`pwd`
input=$1
input2=$2
queue=$3
if [[ "x" == "x$queue" ]]; then
  queue=`/home/koen/.scrpts/qsmk2.sh | grep "Free" | awk '{print $2}'`
fi                                                                        
echo "in=$input, in=$input2, g=$queue"

workdir=/temp0/`whoami`

cat <<EOF >dinp.inp
. /usr/local/chem/dalton-2018/vars
DALTON=/usr/local/chem/dalton-2018/dalton

PROCS=\$(cat \$PBS_O_NODEFILE | wc -l)

export DALTON_TMPDIR=$workdir
[ ! -d $workdir ] && mkdir -p $workdir
cd $workdir
[ -d ./DALTON_scratch* ] && rm -r DALTON_scratch*
[ -n $workdir ] && cat > rmfile && rm *

cp $indir/$input $workdir
cp $indir/$input2 $workdir
EOF

if [ $resflag == 0 ]; then
cat <<EOF >>dinp.inp
\$DALTON -dal ${input%.dal} -mol ${input2%.mol} -N \$PROCS
cp * $indir
EOF
else
tarfile=${input%.dal}_${input2%.mol}
cat <<EOF >>dinp.inp
cp $indir/$tarfile.tar.gz $workdir
\$DALTON -f $tarfile -dal ${input%.dal} -mol ${input2%.mol} -N \$PROCS
cp * $indir
EOF
fi
qsub -q $queue dinp.inp
rm -f dinp.inp

