#!/bin/bash
## shapeit prephasing on clusterfs main bash script, need to replace ##par1## by 1:22

mkdir -p ~/SCRATCH/shapeit
cd ~/SCRATCH/shapeit
mkdir -p ref
cd ~/SCRATCH/shapeit/ref
s3cmd get s3://bioinformatics_scratch/zhenyu/shapeit/ref/1000GP_Phase3.sample
s3cmd get s3://bioinformatics_scratch/zhenyu/shapeit/ref/1000GP_Phase3_chr##par1##.legend.gz
s3cmd get s3://bioinformatics_scratch/zhenyu/shapeit/ref/1000GP_Phase3_chr##par1##.hap.gz
s3cmd get s3://bioinformatics_scratch/zhenyu/shapeit/ref/genetic_map_chr##par1##_combined_b37.txt
cd ~/SCRATCH/shapeit
mkdir -p output
cd ~/SCRATCH/shapeit/output
export http_proxy=http://cloud-proxy:3128; export https_proxy=http://cloud-proxy:3128;
sudo -E apt-get install libboost-iostreams1.55.0
sudo -E apt-get install libboost-program-options1.55.0
shapeit \
	--input-bed    ~/shapeit/data/chr##par1##.flipped.again --thread 30 \
	--input-map    ~/SCRATCH/shapeit/ref/genetic_map_chr##par1##_combined_b37.txt \
	--output-max   ~/SCRATCH/shapeit/output/##par1##.phased \
	--output-graph ~/SCRATCH/shapeit/output/##par1##.hgraph \
	--output-log   ~/SCRATCH/shapeit/output/##par1##.log \
	--input-ref    ~/SCRATCH/shapeit/ref/1000GP_Phase3_chr##par1##.hap.gz \
	               ~/SCRATCH/shapeit/ref/1000GP_Phase3_chr##par1##.legend.gz \
	               ~/SCRATCH/shapeit/ref/1000GP_Phase3.sample 
s3cmd put ~/SCRATCH/shapeit/output/* s3://bioinformatics_scratch/zhenyu/shapeit/chr##par1##/

