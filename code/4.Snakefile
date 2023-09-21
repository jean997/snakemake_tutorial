
rule all_stats:
    input: expand("results/chr{c}_stats.txt", c = range(20, 23))

rule all_concat:
    input: "data/all.vcf.gz"
    default_target: True

rule get_stats:
    input: "data/chr{c}.vcf.gz"
    output: "results/chr{c}_stats.txt"
    shell: "mkdir -p results; bcftools stats {input} > {output}"

rule combine_data:
    input: expand("data/chr{c}.vcf.gz", c = range(20, 23))
    output: "data/all.vcf.gz"
    shell: "bcftools concat -o {output} {input}"

## This rule is equivalent to the one above
#rule combine_data:
#    input: chr20 = "data/chr20.vcf.gz", chr21 = "data/chr21.vcf.gz", chr22 = "data/chr22.vcf.gz"
#    output: out = "data/all.vcf.gz"
#    shell: "bcftools concat -o {output.out} {input.chr20} {input.chr21} {input.chr22}"
