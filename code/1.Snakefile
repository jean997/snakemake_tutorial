
rule all:
    input: "results/chr21_stats.txt", "results/chr22_stats.txt"

rule get_stats22:
    input: "data/chr22.vcf.gz"
    output: "results/chr22_stats.txt"
    shell: "mkdir -p results; bcftools stats data/chr22.vcf.gz > results/chr22_stats.txt"

rule get_stats21:
    input: "data/chr21.vcf.gz"
    output: "results/chr21_stats.txt"
    shell: "mkdir -p results; bcftools stats data/chr21.vcf.gz > results/chr21_stats.txt"


