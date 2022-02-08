#!/bin/bash
## qsmk2.sh
# gives available g-nodes, based on qsm and qst
[[ $# == 0 ]] && vnum=5 || vnum=$1
[[ "$vnum" == "a"* ]] && vnum=99
#TODO: add p-compatibility

vstat=($(qstat -u `whoami`| tail -n+6))
vnode="gx"
nnode=2
nodelist=()
until [[ $vnode == "" ]]; do
    vnode=${vstat[$nnode]}
    nnode=$(($nnode+11))
    if [[ ! " ${nodelist[@]} " == *" $vnode "* ]]; then
      nodelist+=($vnode)
    fi
done

vartot=($(qsum -gu | grep -A $(($vnum+5)) 'free' | tail -n $(($vnum+5)) ))
#should maybe be increased to 6 or 7.. if for some reason an error occurs

# get the first elements with a g AND not part of nodelist
# loops stops when vartot is finished
freelist=()
i=0
until [[ $((${#freelist[@]} + ${#nodelist[@]})) -ge $vnum ]]; do
    [[ "x${vartot[$i]}" == "x" ]] && break
    [[ ${vartot[$i]} == "g"* ]] && [[ ! " ${nodelist[@]} g1 g2 " == *" ${vartot[$i]} "* ]] && freelist+=(${vartot[$i]})
    i=$(($i+1))
done

echo "Used: ${nodelist[@]}"
echo "Free: ${freelist[@]}"
