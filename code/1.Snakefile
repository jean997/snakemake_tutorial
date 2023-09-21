
rule all:
    input: "results/chr22_stats.txt"

rule get_stats:
    input: "data/chr22.vcf.gz"
    output: "results/chr22_stats.txt"
    shell: "mkdir -p results; bcftools stats data/chr22.vcf.gz > results/chr22_stats.txt"

