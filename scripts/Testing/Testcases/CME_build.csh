#!/bin/csh -f
setenv CIMEROOT `./xmlquery CIMEROOT    -value`

./Tools/check_lockedfiles || exit -1

# NOTE - Are assumming that are already in $CASEROOT here
set CASE     = `./xmlquery CASE    -value`
set EXEROOT  = `./xmlquery EXEROOT -value`

./xmlchange USE_ESMF_LIB=TRUE

#------------------------------------------------------------
./xmlchange COMP_INTERFACE=MCT
./case.clean_build

./case.build --testmode
if ($status != 0) then
   exit -1    
endif 

mv -f $EXEROOT/${CIME_MODEL}.exe $EXEROOT/${CIME_MODEL}.exe.mct
cp -f env_build.xml      env_build.xml.mct

#------------------------------------------------------------
./xmlchange COMP_INTERFACE=ESMF
./case.clean_build

./case.build --testmode
if ($status != 0) then
   exit -1    
endif 

mv -f $EXEROOT/${CIME_MODEL}.exe $EXEROOT/${CIME_MODEL}.exe.esmf
cp -f env_build.xml  env_build.xml.esmf




