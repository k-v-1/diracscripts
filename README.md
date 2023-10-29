All scripts for starting calculations on Dirac.
Most have a *help* message, which can be printed by executing the script with the -h flag.
Most submitscripts work as follows (node is optional, since qsmk2.sh will choose a node if none is given):
```bash
script $filename $node
#example:
run_fcc.sh fcclasssinput.inp g5
```
However, using s1 is often much easier, since multiple files and nodes can be given in one command.

# s1 - the ultimate submitscript
The main script is **s1**, which can be used to start:
  - Gaussian
  - Orca
  - Q-chem
  - FCClasses
  - Dalton  

s1 calls other scripts (resp. s2, run_orca.sh, q_run.sh, run_fcc.sh, dal.sh) to submit calcs for each of these softwares.  
Possible to use multiple input files (except for dalton maybe?), which makes it more convenient than for example subg16 imo.  
Automatic free node selection is based on the qsmk2.sh script, but is now also in the s1 script itself (to have one less dependency).  
It is of course also possible to assign one or more nodes yourself, by just adding them as arguments.

### qsmk2.sh
Gives free nodes, based on qsum and qstat.  
Defaults to 5 nodes in total, but all free nodes can be given with a/-a/--all flag or a certain number can be printed by given this number as arg.  
p/-p flag gives p-nodes and g/-g flag gives g-nodes (default).  

> *Fun fact: qsmk2 originally comes from the command **qs**u**m** -u **k**oen, **2**nd version* (#logic naming!)

# s2 - the ultimate subg16 replacement (version 4.1)
Start gaussian16 calculations, but more robust than subg16.  
Automatic chk, wfn or cube detection in input + copying afterwards, so no need to mess around with manual copying from the node.  
Checks input if chk-name is the same as filename, but can be turned of by setting *checkchk=False* at line 5.  
> *Fun fact: s2 comes from the second subg16 script (which was abbreviated for fast typing purposes)  
>  Afterwards, s1 was made originally as a better input parser for s2, but later extended to include multiple softwares*

# fchk_dirac.sh
*Only non-submitscript in this repo?*  
Convenient and robust script to convert (multiple) **chk**-files to **fchk**-files.  
uses /usr/local/chem/g16A03/formchk  

# run_orca.sh
Works with latest version of ORCA5 (from /usr/local/chem/orca5).  
checks nr of processors with yellowdog-script.  
checks input and copies xyz- and hess- files.

# q_run.sh
basic qchem script, I never really had to use more advanced features in qchem.

# run_fcc.sh
copies *\*.fcc, \*.inp and \*.fchk* from the input directory to the working directory.  
if g999 is given as node, the jobfile is created, but not submitted.  

# dal.sh
It has been ages since i've used dalton, but i think this script will still work.  
arg1 is the input (ending on .dal), while arg2 is the mol-file (ending on .mol).  
with s1, one can choose between giving one dalfile and multiple molfiles, or one molfile and multiple dalfiles.


---
* * *
## deprecated scripts
* del (used instead of rm, to move files to a recycle bin instead of deleting)
* run_dscf.sh, run_ricc2.sh, xturb\*-scripts (used for adc(2) calculations in turbomole, but wasn't very user friendly and there is a new tm version anyway)
* s3 (attempt to separate inputs when combining TDA, OPT+FREQ and TD(triplets?), but never really worked decently)
