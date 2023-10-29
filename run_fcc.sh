#!/bin/bash
fcdir=/usr/local/chem/fcclasses-3.1.0  # TODO: change this whenever fcc-classes is updated on Dirac
input=`basename $1`
indir=$PWD/`dirname $1`
queue=$2
tdir=/temp0/`whoami`/FCC
# If queue is not given it's determined automatically by following script.
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
#rsync $indir/* .  # TODO: uncomment this if you use files not ending on .fcc/.inp/...

$fcdir/bin/fcclasses3 $input
rsync * $indir --exclude="*.fchk"


EOF
[[ ! "$queue" == "g999" ]] && qsub -q $queue $input.job -N ${input%.inp}
#rm $input.job
