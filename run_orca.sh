#!/bin/bash
indir=`pwd`
input=$1
queue=$2
tdir=/temp0/`whoami`/ORCA
if [[ "x" == "x$queue" ]]; then
  queue=`/home/koen/.scrpts/qsmk2.sh | grep "Free" | awk '{print $2}'`
fi                                                                        
#np=($(pbsnodes -aq "node${queue:1}" | grep "np = " | awk '{print $3}'))  # gives sometimes wrong number of processes
np=($(/home/hvs/python/yellowdog/yellowdog.py node get --node node${queue:1} | grep -oE '(n_processors\": [0-9]+|cores_per_processor\": [0-9]+)' | awk -v s=1 '{s*=$NF} END{print s}'))
echo "$queue ($np)"
#input parsing: xyz, hess, ...
if grep -iq "%pal nprocs" $input; then
    sed -i "s/nprocs .*$/nprocs $np/" $input
else
    sed -i -E "s/^([ ]*\*.*[xX][yY][zZ].*)$/%pal nprocs $np\nend\n\n\1/" $input; fi
xfiles=($(grep -i "xyzfile" $input |grep -Eiow "[0-Z/_.-]+.xyz")) # only relative paths! No ~or/
  #xfiles=($(grep -Eiow "[a-Z/_.-]+.xyz" $input))
hessfiles=($(grep -Eiow "[0-Z/_.-]+.hess" $input))

#create job-file
cat <<EOF >$input.job
ORCA=/usr/local/chem/orca5
MPI=/usr/local/openmpi-4.1.1-gcc-10.3.0
export PATH=\$ORCA/bin:\$MPI/bin:\$PATH
export RSH_COMMAND=/usr/bin/ssh
export OMP_NUM_THREADS=1
export LD_LIBRARY_PATH=\$MPI/lib:\$ORCA/lib

#for node in \$(cat \$PBS_NODEFILE|uniq); #do
#    ssh \$node "mkdir -p $tdir"; #done

[ ! -d $tdir ] && mkdir -p $tdir
cd $tdir
find . -type f -not -name \'$input*\' -delete
rm ./*.{gbw,inp,out}

head -1 \$PBS_NODEFILE > ${input%.inp}.nodes

cp $indir/$input .
for fl in ${xfiles[@]} ${hessfiles[@]}; do
    cp "$indir/\$fl" .; done
[[ -s "$indir/${input%.inp}.gbw" ]] && cp $indir/${input%.inp}.gbw .

\$ORCA/bin/orca $input > ${input%.inp}.out 2> $input.err
[[ -s "$input.err" ]] || rm $input.err
mkdir -p $indir/${input%.inp}

if [[ \`du -s $tdir | awk '{print \$1}'\` -lt 10000000 ]]; then
cp ${input%.inp}.* $indir/${input%.inp}
cp ${input%.inp}.out $indir
else
cp ${input%.inp}.out $indir
cp $input.err $indir
cp ${input%.inp}.gbw $indir/${input%.inp}
echo "scratch still full; not copying everything to home" >> $input.err
fi

EOF
qsub -q $queue $input.job -N ${input%.inp}
rm $input.job
