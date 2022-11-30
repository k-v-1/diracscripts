#!/bin/bash
## qsmk2.sh
# gives available g-nodes, based on qsm and qst
# added p-functionality with gp-variable

#update: better arg parsing

vnum=5
gp=g
[[ $# -gt 3 ]] && echo "number of arguments is greater than 3. exit" && exit 1
while [[ $# -gt 0 ]]; do
case $1 in
    -h|--help)           printf "shows used and free nodes.\n-a/--all : show all free nodes, otherwise limited to 5\n-p       : show p-nodes instead of g-nodes\n"; exit 0;;
    a|-a|--all)          vnum=99; shift;;
    p|-p)                gp=p; shift;;
    ap|-ap|pa|-pa)       vnum=99;gp=p; shift;;
    [0-9]|[0-9][0-9])    vnum=$1; shift;;
    *)                   echo "$1 is neither -a/-p, nor number: exit"; exit 1;;
esac
done


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
