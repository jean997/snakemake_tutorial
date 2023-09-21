
rule all:
    input: expand("results/chr{c}_stats.txt", c = range(20, 23))

rule get_stats:
    input: "data/chr{c}.vcf.gz"
    output: "results/chr{c}_stats.txt"
    shell: "mkdir -p results; bcftools stats {input} > {output}"

