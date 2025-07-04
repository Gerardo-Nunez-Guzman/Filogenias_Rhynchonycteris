#!/bin/bash

# Unir todos los arboles en un solo documento
cd Iqtree/
cat *.treefile > AllTrees.tree

# Crear variable para correr Astral desde cualquier lugar en Hoffman
astral=/u/scratch/d/dechavez/Bioinformatica-PUCE/RediseBio/GerardoNG/Final.project/Scripts/astral.5.7.8.jar

# Get species tree from gene trees
java -jar $astral -i AllTrees.tree -o AstralTree.tree 

# Genes concordance factor
module load iqtree/2.2.2.6
iqtree2 -t AstralTree.tree --gcf AllTrees.tree --prefix Concord
cd ..
mkdir ConcordTree
mv Iqtree/Concord* ConcordTree/
