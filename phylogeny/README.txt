### 1. ILP homologs are identified from each of he 71 hymenotperan genomes in the NCBI RefSeq database (see "Hymenoptera.RefSeq_Assembly_id.tsv") as follows:

# GCF_000204515.1 is used as an example here

# 1.a to obtain annotated protein sequences using the NCBI DataSets application:
datasets download genome accession GCF_000204515.1 --exclude-gff3 --exclude-protein --exclude-rna --exclude-seq
unzip ncbi_dataset.zip
mv ncbi_dataset/data/GCF_000204515.1/rna.fna GCF_000204515.1.cds
perl reformat_seq_name.pl ncbi_dataset/data/GCF_000204515.1/cds_from_genomic.fna GCF_000204515.1 > GCF_000204515.1.cds
transeq -sequence GCF_000204515.1.cds -outseq GCF_000204515.1.pep -clean

# 1.b to identify protein domains using InterProScan:
interproscan.sh -i GCF_000204515.1.pep -b GCF_000204515.1.interproscan -iprlookup -dp

# 1.c to extract protein sequences containing IPR016179, the characteristic InterPro domain of ILP:
perl extract_ILP_homologs.pl GCF_000204515.1.pep GCF_000204515.1.interproscan.tsv > GCF_000204515.1.IPR016179.pep


### 2. all protein sequences containing IPR016179 are combined into one file name "hymenoptera.IPR016179.pep"


### 3. to generate multiple sequence alignment using MAFFT:
mafft --genafpair --maxiterate 1000 --reorder hymenoptera.IPR016179.pep > hymenoptera.IPR016179.pep.aln


### 4. to trim gappy columns in the MSA:
trimal -gappyout -in hymenoptera.IPR016179.pep.aln -out hymenoptera.IPR016179.pep.gappyout.aln


### 5. to build the phylogeny of hymenopteran ILP homologs:
iqtree-omp --runs 20 -m MFP -B 1000 --bnni -s hymenoptera.IPR016179.pep.gappyout.aln --prefix hymenoptera.IPR016179.pep.gappyout.iqtree
