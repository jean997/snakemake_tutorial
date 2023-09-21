#!/bin/bash

mkdir -p log
snakemake \
   -s 9.Snakefile \
   --use-conda \
   --conda-frontend conda \
   --keep-going \
   --jobs 96 \
   --max-jobs-per-second 5 \
   --latency-wait 60 \
   --cluster-config cluster.yaml  \
   --cluster "sbatch \
              --output={cluster.log}_%j.out \
              --error={cluster.log}_%j.err \
              --account=jvmorr0 \
              --job-name={cluster.name} \
              --time={cluster.time}  \
              --cpus-per-task={cluster.cpus}  \
              --mem={cluster.mem}"

