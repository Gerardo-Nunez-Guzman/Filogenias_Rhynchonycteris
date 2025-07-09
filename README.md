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
*Note:* This analysis was performed using Shell as programming language. 
-----

### Part 1: Downloading the sequences from NCBI
* First, let's create the directory where we'll do the analysis.
```
mkdir Phylogeny
```
* Next up, let's create a new folder in Phylogeny where we'll keep all the "original" sequences we're working with.
```
cd Phylogeny
mkdir Fasta
```
#### Now, let's download the markers from NCBI.

-----
*Note:* At NCBI there are two databases in which the sequences are stored, one for mitochondrial or chloroplastic sequences and one for autosomal sequences. Don't worry, though, because lots of the authors who upload these sequences to the cloud do so in the mitochondrial database. This means that so much of this information is available in this directory and not in the other. For that reason all sequences are going to be downloaded from the mitogenomic material directory.
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
for x *_*.fasta
do
	gen=${file%%_*}
	cat ${gen}_*.fasta > ${gen}.fasta
done
```