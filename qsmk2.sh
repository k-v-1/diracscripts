#!/bin/bash
## qsmk2.sh
# gives available g-nodes, based on qsm and qst
# added p-functionality with gp-variable

#arg-parsing: -p: give p-nodes instead of g
#           arg2: total number of nodes to print, or 'a'=all available nodes
gp=g
[[ "$1" == "-p" ]] && gp=p && shift
[[ $# == 0 ]] && vnum=5 || vnum=$1
[[ "$vnum" == "a"* ]] && vnum=99

#check which nodes are free with qstat, should work across users due to 'whoami'
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

#get list of free nodes, based on user availability due to -u flag?
vartot=($(qsum -${gp}u | grep -A $(($vnum+5)) 'free' | tail -n $(($vnum+5)) ))
#should maybe be increased to 6 or 7.. if for some reason an error occurs --> so far not necessary

# get the first elements with a g/p AND not part of nodelist or forbidden list (g1 and g2)
# loops stops when vartot is finished
freelist=()
i=0
until [[ $((${#freelist[@]} + ${#nodelist[@]})) -ge $vnum ]]; do
    [[ "x${vartot[$i]}" == "x" ]] && break
    [[ ${vartot[$i]} == "${gp}"* ]] && [[ ! " ${nodelist[@]} g1 g2 " == *" ${vartot[$i]} "* ]] && freelist+=(${vartot[$i]})
    i=$(($i+1))
done

echo "Used: ${nodelist[@]}"
echo "Free: ${freelist[@]}"
