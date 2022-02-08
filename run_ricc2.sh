#!/bin/bash
[[ $2 == "--long" ]] && long=true || long=false
queue=$1
indir=`pwd`
name=`basename $indir`
name=`echo "ricc2_${name}" | cut -c1-15 `
usrname=`whoami`

if grep -Fq "cosmo" $indir/control; then
smpser="ser"                            
else                                    
smpser="smp"                            
fi                                      
                                        

cat <<END > ric.job
. /usr/local/chem/turbomole7.1/vars.$smpser

cd /temp0/$usrname
cat > rmfile
rm *
cp $indir/* .
END

if [[ "$long" == "false" ]]; then
    echo 'ricc2 > ricc2.out' >> ric.job
else
cat <<END >> ric.job
ricc2 > ricc2.out &; pid=\$!
trap "kill \$pid 2> /dev/null" EXIT
while kill -0 \$pid 2>/dev/null; do
touch *
sleep 3600
done
END
fi

echo "rm CC* *.cao; cp * $indir" >> ric.job

qsub -q $queue ric.job -N $name
