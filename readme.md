## Pipeline that generates amplicon sequencing data using BioGrinder

# Features of the pipeline
    - Generating rRNA amplicon sequencing data using BioGrinder
    - Adding a start and end primer to the given target database
    - Combining output files of BioGrinder amplicons sequencing data to one file containing forward amplicons and one file containing reverse amplicons

# Running the Pipeline
    - Pull the main branch from github
    - Install the needed dependencies
        - BioGrinder
    - run the BioGrinder.sh with the correct parameters(described bellow)
    - Ouput directory will be created in the output folder

# Parameters
    - Mandatory parameters:
        - "-d (Database name)" Use this paraemter to give the name of the database that will be used. 
            - Mandatory.
        - "-n (Name for the run)" Use this parameter to give a name to the pipeline run.
            - Mandatory.
    - Change default values:
        - "-r (Amplicon length)" Use this parameter to change the read length. 
            - Default is 151.
        - "-p (Primer file)" Use this parameter to change the name of the primer file that will be used.
            - Default is RC-PCR-primers-changed.fasta.
    - Optional parameters:
        - "-x" Add this paramameter to add the first forward and last reverse primer to you target database.
            - Optional.
        - "-a (abundence file name)" This parameters enables to specify the relative abundance of the reference sequences manually in an input file.
            - Optional.

# Development
    - For development follow the following steps:
        - Pull the main branch
        - Make sure all the dependencies are installed
    - For testing during development:
        - Add a fasta file contanining a 16S/18S database in the /data/database directory
        - Add a fasta file containing the primers in the /data/primers directory
        - Run the BioGrinder.sh script with the correct parameters(described above)