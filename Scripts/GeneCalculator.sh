# Para alinear las seciencias
cd Fasta
for x in *.fasta; do ../Scripts/muscle3.8.31_i86linux64 -in $x -out muscle_$x; done

# Cargar iqtree
module load iqtree/2.2.2.6

# Para hacer filogenias
iqtree2 -s muscle_COI.fasta -m GTR+F+I+G4
iqtree2 -s muscle_Cytb.fasta -m HKY+I+G
iqtree2 -s muscle_Dby.fasta -m GTR+I
iqtree2 -s muscle_Chd1.fasta -m HKY+I
iqtree2 -s muscle_Usp9x.fasta -m HKY+I

# Ordenar los archivos en carpetas independientes
cd ..
mkdir Muscle/ Iqtree/
mv Fasta/*.treefile Iqtree/
mv Fasta/muscle_* Muscle/
