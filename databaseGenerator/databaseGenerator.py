from Bio import SeqIO
import random


def main():
    databaseRecords = parseDatabase()
    exportRandomSequence(databaseRecords, 1)


def parseDatabase():
    databaseRecords = []
    for record in SeqIO.parse(
            "/home/brian/Documents/afstudeerstage/bioGrinderPipeline/databaseGenerator/aspergilllus.fasta", "fasta"):
        databaseRecords.append([record.description, record.seq])

    return databaseRecords


def exportRandomSequence(databaseRecords, amountOfSequences):
    outF = open("bioGrinder.fasta", "w")

    for i in range(amountOfSequences):
        randomChoice = random.randint(0, len(databaseRecords))
        outF.write(">" + str(databaseRecords[randomChoice][0]) + "\n")
        outF.write(str(databaseRecords[randomChoice][1]) + "\n")

    outF.close()


main()
