#!/bin/bash
fcdir=/usr/local/chem/fcclasses-3.1.0
indir=`pwd`
input=$1
queue=$2
tdir=/temp0/`whoami`/FCC
if [[ "x" == "x$queue" ]]; then
  queue=`/home/koen/.scrpts/qsmk2.sh | grep "Free" | awk '{print $2}'`
fi                                                                        
echo "$queue"
#input parsing for necessary files

#create job-file
cat <<EOF >$input.job
export LC_ALL=C
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$fcdir/extralib
. $fcdir/vars

[ ! -d $tdir ] && mkdir -p $tdir
cd $tdir
rm *.dat *.fcc *.out *.inp

rsync $indir/{$input,*.fcc,*.inp,*.fchk} .

$fcdir/bin/fcclasses3 $input
rsync * $indir --exclude="*.fchk"


EOF
qsub -q $queue $input.job -N ${input%.inp}
#rm $input.job
