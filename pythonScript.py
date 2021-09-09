### Defining the name of the file. You can change it according to your file name.
file = "GRCh38_latest_genomic.gff"

## Function No 1
#### I used this function to read the lines in the file and making a list
#### The list contains only those lines that have our desired gene name in it.
def getGenesLines(file, gene):
    """
    returns a list of those lines having the specific genes (keywords)

    Keyword arguments:
    file -- GFF file 
    gene -- name of the gene

    Keyword Details:
    file: this argument is supposed to be a string with extension of the file
    gene: this argument is supposed to be a string as well
    """
    list = [] 						## Inatializing an empty list
    with open(file) as newgff:		## Opening the file
        for line in newgff:			## inatializing the for loop
            if gene in line:			## Checking if the line contains the secific gene
                list += line				## Appending the list with line
    return list					## Returning the list



## Function No 2
#### I used this function to read the lines in the file and making a list
#### The text file is supposed to contain the names of the genes
#### Each line should contain a new name of the gene
#### if line starts with ">" that will be skipped
def getGeneName(file): 
    """
    returns a list of those lines haveing the specific genes (keywords)

    Keyword arguments:
    file --txt file 

    Keyword Details:
    file:    this argument is supposed to be a string with extension of the file
    		also each gene name in the file should start with new line.
    """
    geneslist = []						## Inatializing an empty list
    with open(file) as genesfile:		## Opening the file
        lines = genesfile.readlines()		## Reading the lines and storing in lines variable
        for line in lines:				## Inatializing the for loop over lines.
            if line[0] == ">":				## Checking if the line startes with ">"
                pass						## continuing the loop
            else:							
                geneslist.append(line[:-1])	## Adding new line in the gene list
    return geneslist					## Returning the gene list


## Function No 3
#### I used this function to write a new file
#### this function needs a list that has strings and writes each string in new line
def writeGFF(geneLines, fileName):
    """
    writes a new file with a specific name and extension

    Keyword arguments:
    geneLines -- list  
    fileName -- name of the file with extension

    Keyword Details:
    geneLines: this argument is supposed to be a list with strings
     			  new line character should be at the end of every element of the list

    fileName: this argument is supposed to be a string with extension of the file
    			also each gene name in the file should start with new line.
    """
    with open(fileName, "a") as file:	## Creating a new file with the given file name in append mode
        for line in geneLines:			## inatializing the for loop over the list
            file.writelines(line)			## writing lines in the file


### calling the getGeneName() function and storing the list in geneNames variable
geneNames = getGeneName("protamine bound genes.txt")

### looping over the geneNames
for gene in geneNames: 									# Inatializing the loop
    currGeneList = getGenesLines(file, gene)				    # calling the getGenesLines() to get the lines from the GFF file
    writeGFF(currGeneList, "selectedGenesprotamine.gff")	    # Writing or appending the gff file
    



