	# firstHeader=$(head -n 1 ${baseDir}/data/primers/${primerFile} | cut -d ">" -f 2)
	# lastHeader=$(tail -2 ${baseDir}/data/primers/${primerFile} | head -1 | cut -d ">" -f 2) 
	# if [ ! -z "$forwardPrimerCutoff" ]; then
	# 	echo "inn"
	# 	if [[ "$f" =~ .*"$firstHeader".* ]]; then
	# 		echo "andere lengte"
	# 		adaptedReadLength= $readDistance - $forwardPrimerCutoff
	# 		bioGrinderParameters="-reference_file ${baseDir}/data/database/${database} -forward_reverse ${baseDir}/${f} -length_bias 0 -unidirectional -1 -fq 1 -ql 30 10 -rd ${adaptedReadLength}"
	# 	else
	# 		  bioGrinderParameters="-reference_file ${baseDir}/data/database/${database} -forward_reverse ${baseDir}/${f} -length_bias 0 -unidirectional -1 -fq 1 -ql 30 10 -rd ${readDistance}"
	# 	fi
  
	# elif [ ! -z "$reversePrimerCutoff" ]; then
	# 	echo "inn"
	# 	if [[ "$f" =~ .*"$lastHeader".* ]]; then
	# 		adaptedReadLength= $readDistance - $reversePrimerCutoff
	# 		bioGrinderParameters="-reference_file ${baseDir}/data/database/${database} -forward_reverse ${baseDir}/${f} -length_bias 0 -unidirectional -1 -fq 1 -ql 30 10 -rd ${adaptedReadLength}"

	# 	else
	# 		  bioGrinderParameters="-reference_file ${baseDir}/data/database/${database} -forward_reverse ${baseDir}/${f} -length_bias 0 -unidirectional -1 -fq 1 -ql 30 10 -rd ${readDistance}"
	# 	fi
  	# else
	#   	  echo "jajajajaj"
	# 	  bioGrinderParameters="-reference_file ${baseDir}/data/database/${database} -forward_reverse ${baseDir}/${f} -length_bias 0 -unidirectional -1 -fq 1 -ql 30 10 -rd ${readDistance}"	
	# fi