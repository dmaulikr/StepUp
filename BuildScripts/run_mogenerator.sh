#!/bin/sh

#  run_mogenerator.sh
#  Updates Core Data generated classes - requires mogenerator
#
#  Created by Sasmito Adibowo on 28-11-11.
#	 Updated by Mario Mir, Eelco Koelewijn 2014

#baseClass=NSManagedObject
baseClass=AFLSerializationManagedObject

function update_model()
{
	echo "full path: ${1}";
    tmpfileDir=`dirname "${1}"`
    fileDir=`dirname "$tmpfileDir"`
    echo "models path: $fileDir"

		curVer=""
		if [ -s "${tmpfileDir}/.xccurrentversion" ]; then
    	curVer=`/usr/libexec/PlistBuddy "${tmpfileDir}/.xccurrentversion" -c 'print _XCCurrentVersionName'`
			echo "Current model version: $curVer"
		fi


    # Mogenerator Location
    if [ -x /usr/local/bin/mogenerator ]; then
        echo "mogenerator exists in /usr/local/bin path";
        MOGENERATOR_DIR="/usr/local/bin";
        echo /usr/local/bin/mogenerator  --model "${tmpfileDir}/$curVer" --output-dir "${fileDir}/" --base-class $baseClass  --template-var arc=true
#/usr/local/bin/mogenerator --model "${1}" --output-dir "${fileDir}/" --base-class $baseClass  --template-var arc=true
    elif [ -x /usr/bin/mogenerator ]; then
        echo "mogenerator exists in /usr/bin path";
        MOGENERATOR_DIR="/usr/bin";
        echo mogenerator  --model "${tmpfileDir}/$curVer" --output-dir "${fileDir}/" --base-class $baseClass  --template-var arc=true
    fi

	if [ -z $curVer ]; then
		$MOGENERATOR_DIR/mogenerator --model "${tmpfileDir}" --output-dir "${fileDir}/" --base-class $baseClass  --template-var arc=true
	else
		$MOGENERATOR_DIR/mogenerator --model "${tmpfileDir}/$curVer" --output-dir "${fileDir}/" --base-class $baseClass  --template-var arc=true
	fi

}

find . -iname \*.xcdatamodel -print0 -quit | while read -d $'\0' i; do update_model "$i"; done
