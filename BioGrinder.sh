#!/bin/bash
# -d fumigatus.fasta
# -p RC-PCR-primers.fasta
# Default paramters
outputDir=false
readDistance=151
fastq=true
baseDir=$(pwd)
databaseModification=false
# Parsing given parameters.
while getopts "r:d:p:n:a:f:r:x" OPTION; do
	case $OPTION in
		r) 
        readDistance=${OPTARG}
		;;
		d) 
        database=${OPTARG}
		;;
        p)
        primerFile=${OPTARG}
		;;
		n)
		runName=${OPTARG}
		;;
		x)
		databaseModification=true
		;;
		a)
		abundanceFile=${OPTARG}
		;;
	esac
done

# Check for mandatory parameters
if [ -z "$runName" ]; then
        echo 'Missing -n' >&2
        exit 1
fi

# Check for mandatory parameters
if [ -z "$database" ]; then
        echo 'Missing -d' >&2
        exit 1
fi

# Check for mandatory parameters
if [ -z "$primerFile" ]; then
        echo 'Missing p' >&2
        exit 1
fi

# Create primer file for each primer
boolean=false
header=""

# Open pimer file
while read p; do
	# Check for forward primers
	if [[ "$p" =~ .*"F".* ]]; then
		boolean=true
		header=${p}
	# Check for reverse primers
  	elif [[ "$p" =~ .*"R".* ]]; then
		boolean=false
		header=${p}
	# Just a sequence
	else
	  	fileName=${header/">"/""}
		echo "${header}" > data/createdPrimerFiles/${fileName}.fasta
		echo "${p}" >> data/createdPrimerFiles/${fileName}.fasta
  	fi
done < "${baseDir}/data/primers/${primerFile}"

# Check if modification of database is needed
if [[ "$databaseModification" == "true" ]]; then
	firstPrimer=$(grep -m 2 -o '.*' ${baseDir}/data/primers/${primerFile} | cut -d ':' -f 1 | tail -n 1 )
	lastPrimer=$(tail -1 ${baseDir}/data/primers/${primerFile}) 
	reverseComplementLastPrimer=$(echo $lastPrimer | tr ACGTacgt TGCAtgca | rev)
	
	# Open given database
	while read p; do
		# Check for fasta headers
		if [[ "${p}" =~ ">".* ]]; then
			echo ${p} >> ${baseDir}/data/database/modifiedDatabase.fasta
		# All the other fasta lines
		else
			echo "$firstPrimer$p$reverseComplementLastPrimer" >> ${baseDir}/data/database/modifiedDatabase.fasta
		fi
	done < "${baseDir}/data/database/${database}"
	
	# Change database to modified database
	database="modifiedDatabase.fasta"
fi

# Running BioGrinder for all primer files
FILES="data/createdPrimerFiles/*"
for f in $FILES
do
  # Define parameters for BioGrinder	  
  bioGrinderParameters="-reference_file ${baseDir}/data/database/${database} -forward_reverse ${baseDir}/${f} -length_bias 0 -unidirectional -1 -fq 1 -ql 30 10 -rd ${readDistance}"	

  # Add parameter if it is given be the user
  if [ ! -z "$abundanceFile" ]; then
  	bioGrinderParameters="$bioGrinderParameters -af data/$abundanceFile"
  fi

  grinder $bioGrinderParameters
  # Define the string value
  text="$f"
  # Split filePath on .
  readarray -d . -t strarr <<< "$text"
  # Split filePath on /
  readarray -d / -t strarr2 <<< "${strarr[0]}"

  # Name of output file
  outputFileName=`echo ${strarr2[2]}`
  # Move created output
  mv grinder-reads.fastq ${baseDir}/data/BioGrinderFiles/$outputFileName-reads.fastq
  mv grinder-ranks.txt ${baseDir}/data/BioGrinderAnnotationFiles/$outputFileName-ranks.txt
done


# Create directory for output files
mkdir ${baseDir}/output/${runName}

# Counters that keep count of the amount of fastq headers in the file
forwardCounter=0
reverseCounter=0
# Filling files for forward and reverse amplicons
FILES="data/BioGrinderFiles/*"
# Loop over all files in the folder
for f in $FILES
do
	# Split the File name
	readarray -d / -t splitFilename <<< "${f}"
	# Open the file
	while read p; do
		# If the files contains forward amplicons, process them		
		if [[ "${splitFilename[2]}" =~ .*"F".* ]]; then
			# Check if the line is a fastq header
			if [[ "${p}" =~ "@".* ]]; then
				# Up the ID by 1 when a new header is found
				forwardCounter=$(($forwardCounter + 1))

				# Modify the header so it uses the new ID
				newHeader=""
				readarray -d " " -t splitHeader <<< "${p}"
				for val in "${splitHeader[@]}";
				do
					if [[ "${val}" =~ "@".* ]]; then
						newHeader="${newHeader} @${forwardCounter}"
					else
						newHeader="${newHeader} ${val}"
					fi
					
				done
				# Write to the output file
				echo ${newHeader} >> ${baseDir}/output/${runName}/${runName}_forward_reads.fastq
			# All the fastq lines that are not headers
			else
				# Write to the output file
				echo ${p} >> ${baseDir}/output/${runName}/${runName}_forward_reads.fastq
			fi
		# If the files contains reverse amplicons, process them		
  		elif [[ "${splitFilename[2]}" =~ .*"R".* ]]; then
		    # Check if the line is a fastq header
			if [[ "${p}" =~ "@".* ]]; then
				# Up the ID by 1 when a new header is found
				reverseCounter=$(($reverseCounter + 1))
				
				# Modify the header so it uses the new ID
				newHeader=""
				readarray -d " " -t splitHeader <<< "${p}"
				for val in "${splitHeader[@]}";
				do
					if [[ "${val}" =~ "@".* ]]; then
						newHeader="${newHeader} @${reverseCounter}"
					else
						newHeader="${newHeader} ${val}"
					fi
					
				done
				# Write to the output file
				echo ${newHeader} >> ${baseDir}/output/${runName}/${runName}_reverse_reads.fastq
			# All the fastq lines that are not headers
			else
				# Write to the output file
				echo ${p} >> ${baseDir}/output/${runName}/${runName}_reverse_reads.fastq
			fi
		fi
	done < "${baseDir}/${f}"
done

# Zip output files
FILE=${baseDir}/output/${runName}/${runName}_forward_reads.fastq.gz 
if test -f "$FILE"; then
	gzip ${baseDir}/output/${runName}/${runName}_forward_reads.fastq -f
	gzip ${baseDir}/output/${runName}/${runName}_reverse_reads.fastq -f
else
	gzip ${baseDir}/output/${runName}/${runName}_forward_reads.fastq 
    gzip ${baseDir}/output/${runName}/${runName}_reverse_reads.fastq
fi


# Remove all used Files
rm $baseDir/data/database/modifiedDatabase.fasta
rm -rfv data/createdPrimerFiles/*
# rm -rfv data/BioGrinderFiles/*
rm -rfv data/BioGrinderAnnotationFiles/*