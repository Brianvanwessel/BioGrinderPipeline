#./BioGrinder.sh -n "name"-d "database" -p RC-PCR-primers-changed.fasta -x


while getopts "d:" OPTION; do
	case $OPTION in
		d) 
        database=${OPTARG}
		;;
	esac
done

# Check for mandatory parameters
if [ -z "$database" ]; then
        echo 'Missing -d' >&2
        exit 1
fi

FILES="data/$database/*"

# Loop over all files in the folder
for f in $FILES
do
  # Define the string value
  text="$f"
  # Split filePath on /
  readarray -d / -t strarr <<< "$text"
  # Split filePath on .
  readarray -d . -t strarr2 <<< "${strarr[2]}"

  ./BioGrinder.sh -n ${strarr2[0]} -d ${strarr[2]} -p RC-PCR-primers-changed.fasta -x
done