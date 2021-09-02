from os import path
from Bio import SeqIO
import random


def main():
    databaseRecords = parseDatabase()
    primerSequences = parsePrimers()
    possibleSequences = getNumberOfPossibleSequences(databaseRecords,primerSequences)
    usedSequences = []
    for i in range(40):
        usedSequences = exportRandomSequence(databaseRecords, 1,i,primerSequences,possibleSequences,usedSequences)


def parseDatabase():
    databaseRecords = []

    for record in SeqIO.parse(
            "/home/brian/Documents/afstudeerstage/bioGrinderPipeline/databaseGenerator/aspergilllus.fasta", "fasta"):
        databaseRecords.append([record.description, record.seq])
 

    return databaseRecords

def parsePrimers():
    primerSequences = []
    for record in SeqIO.parse(
            "/home/brian/Documents/afstudeerstage/bioGrinderPipeline/databaseGenerator/RC-PCR-primers.fasta", "fasta"):
        primerSequences.append(record.seq)

    return primerSequences

def getNumberOfPossibleSequences(records,primers):
    possibleSequences = 0
    
    for i in range(len(records)):
          foundPrimer=False
          numberOfPrimers=0
          for i2 in range(len(primers)):
                    if primers[i2] in records[i][1]:
                        foundPrimer=True
                        numberOfPrimers+=1
          if foundPrimer == True:
              possibleSequences+=1
    return possibleSequences



def exportRandomSequence(databaseRecords, amountOfSequences,i,primerSequences,numberOfSequences,usedSequences):
    outF = open("samples/aspergillus"+ "-" + str(i+1) +".fasta", "w")
    for i in range(amountOfSequences):
        if numberOfSequences == len(usedSequences):
            break
        correctSequence=True
        while correctSequence:
            randomChoice = random.randint(0, len(databaseRecords)-1)
            if not databaseRecords[randomChoice][0] in usedSequences:
                for i2 in range(len(primerSequences)):
                    if primerSequences[i2] in databaseRecords[randomChoice][1]:
                        correctSequence=False
        usedSequences.append(databaseRecords[randomChoice][0])
        outF.write(">" + str(databaseRecords[randomChoice][0]) + "\n")
        outF.write(str(databaseRecords[randomChoice][1]) + "\n")
    outF.close()
    return usedSequences

main()
