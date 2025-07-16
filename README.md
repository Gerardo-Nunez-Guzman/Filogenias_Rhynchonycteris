Integrative Phylogenetic
=====
Geardo Núñez-Guzmán
16/07/2025

In this guide, I'll show you how to perform an integrative phylogenetic analysis from sequences present in the [National Center for Biotechnology Information (NCBI)](https://www.ncbi.nlm.nih.gov/) from a supercomputer using Shell as a language. There are lots of ways to do this kind of analysis, but some of them can feel a bit tedious because you need to use different programs and files, and you have to work on them one by one. So, the plan is that this guide will help us to improve and automate this type of work, making the most of our computers.

It's also worth mentioning that many of the tools and steps we'll use depend on the needs of our analysis, so they might change a bit, but don't worry, the methodology is always the same.

-----

## Step-by-step walkthrough

In this tutorial, we will work with five types of molecular markers: two from the mitochondria and three from the nucleus. All of these markers come from the emballonurid bat genus *Rhynchonycteris*, and all of the bats in this genus are from the species *Rhynchonycteris naso*. We will also use sequences from *Cyttarops alecto* (another type of bat) to help us analyse our results.

To make the process clearer, the tutorial is divided into four main parts:

**1. Downloading sequences from NCBI**

Here you will learn how to obtain the sequences of the species you are interested in using the EDirect tool.

**2. Making sure that sequences are all the same and correcting any mistakes.**

In this section, I will show you how to make sequences the same and edit them using the Atom text editor. This is very important to avoid problems when putting gene trees together.

**3. How to plant and build individual trees**

Next, we will match up the sequences with Muscle, and then use Iqtree to work out the individual trees for each gene.

**4. Combining and studying gene trees**

Finally, we will combine the gene trees using Astral and then use Iqtree again to calculate the Gene Concordance Factor (gCF).

All the necessary scripts are in the Scripts folder, and the programs we are going to use are in the Programs folder. I'm going to explain how each of these processes works, step by step.In this tutorial, we're going to work with five different scripts. Each one will be used to calculate the Gene Concordance Factor (gCF).

-----
###### *Note:* This analysis was performed using Shell as programming language. 
-----

### Part 1: Downloading the sequences from NCBI (Script= NCBI.sh)
* First, let's create the directory where we'll do the analysis. Next up, let's create a new folder in Phylogeny where we'll keep all the "original" sequences we're working with.

#### Now, let's download the markers from NCBI.

-----
###### *Note:* At NCBI there are two databases in which the sequences are stored, one for mitochondrial or chloroplastic sequences and one for autosomal sequences. Don't worry, though, because lots of the authors who upload these sequences to the cloud do so in the mitochondrial database. This means that so much of this information is available in this directory and not in the other. For that reason all sequences are going to be downloaded from the mitogenomic material directory.
-----


* Then, we created a "forloop" to download all the molecular markers of all the species we chose. To do this, we make two groups of numbers. One group is for the genes, and the other is for the organisms.
```
gene=(“COI” “Cytb” “Dby” “Chd1” “Usp9x”)
organisms=(“Rhynchonycteris naso” “Cyttarops alecto”)
for gen in ${gene[@]}
do
for org in ${organisms[@]}
do
  edirect/esearch -db nuccore -query “$gen[Gene] AND $org[Organism]” | /
  edirect/efetch -format fasta > “Fasta/${gen}_${org}.fasta”
done
done
```

* Finally, we make another "forloop" to bring together the files with the sequences of both species, using the same molecular marker (e.g. COI_Rhynchonycteris naso.fasta COI_Cyttarops alecto.fasta).
```
for x in *_*.fasta
do
	gen=${file%%_*}
	cat ${gen}_*.fasta > ${gen}.fasta
done
```
-----
###### *Note:* As I said in the last note, most of the sequences are uploaded into the mitogenomic information database. This means that when we download, we may have downloaded whole chromosome sequences or even whole genomes. So, it's important to know the type of sequences we have. This helps us to improve our data and avoid problems with later analyses.
-----
### Part 2: Standardization and data purging
* Now that we have our streams downloaded and we have put all the files together, we need to work out what type of streams they are.
```
cat *.fasta | grep “>”
``` 
* Now we are going to delete all the sequences we don't want using this command. We can use it to get rid of different sequences by changing the word "genome", for example to get rid of the ones we don't want.

``` 
for x in *.fasta 
do
awk '/^>/ {if ($0 ~ /genome/) {skip=1; next} else {skip=0}} !skip' $x.fasta > $x_clean.fasta
done
``` 

#### Once this is done, we download our fasta files to make their names the same in the program [Atom](https://atom-editor.cc/). 

-----
###### *Note:* The cleaning data can be found in the 'Data' directory.
-----

### Part 3: Aligning the sequences and making gene trees

* First, we need to match up the sequences that we edited before. We can do this using the muscle programme that is in the 'Programs' folder.
```
cd Fasta
for x in *.fasta
do
../Programs/muscle3.8.31_i86linux64 -in $x -out muscle_$x
done
```

* Next, we'll download Iqtree to the working environment.
```
module load iqtree/2.2.2.6
```

* To do the individual gene phylogenies, we choose an evolutionary model that works for us. In this case, we use the models that already set up by [Biganzoli-Rangel et al., 2023](https://doi.org/10.1371/journal.pone.0285271)

```
iqtree2 -s muscle_COI.fasta -m GTR+I
iqtree2 -s muscle_Cytb.fasta -m HKY+I+G
iqtree2 -s muscle_Dby.fasta -m GTR+I
iqtree2 -s muscle_Chd1.fasta -m HKY+I
iqtree2 -s muscle_Usp9x.fasta -m HKY+I
```
-----
###### *Note:* You don't have to choose an evolutionary model to run the gene trees. You can use the default model that Iqtree has chosen.
```
for x in muscle_*.fasta
do
iqtree -s $x 
done
```
-----

### Final part: *Rhynchonycteris naso* consensus tree

After running the analysis with Iqtree, you'll end up with a bunch of files. The ones we're interested in are those ending in **.treefile**.

* First, we’ll combine the five gene trees generated by Iqtree into a single file:
```
cat *.treefile > AllTrees.tree
```

* Now, using this new file and the Astral program, we’ll build a consensus tree based on the individual trees we got from each of our five markers:
```
java -jar astral.5.7.8.jar -i AllTrees.tree -o AstralTree.tree
```

Again, the analysis will give us several output files, but the one we care about is the one ending in **.tree**. That’s the file we’ll download and open in [FigTree](https://github.com/rambaut/figtree/releases). Once opened, we can edit and style the tree however we like.

-----
###### *Note:* To keep things organized and avoid mistakes during the analysis, it’s a good idea to create folders to sort all your files.
-----

![Final Tree](/c/Users/pc1/Desktop/Filogenias_Rhynchonycteris/FinalTree/FinalTree.png)


All the programs used in this tutorial are available on GitHub. If they’re not already installed on the supercomputer, you can download them from the internet and use them for free.

