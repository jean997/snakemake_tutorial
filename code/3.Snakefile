
rule all:
    input: "results/all_varqc_pca.png" #, expand("results/chr{c}_stats.txt", c = range(20, 23))

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

rule variant_qc:
    input: "data/all.vcf.gz"
    output: multiext("data/all_varqc", ".pgen", ".psam", ".pvar", ".log")
    shell: "plink2 --vcf {input} --set-missing-var-ids '@:#' --snps-only --var-min-qual 95 --geno 0.1 --maf 0.01 --make-pgen --out data/all_varqc "


rule ld_prune:
    input: multiext("data/{prefix}", ".pgen", ".psam", ".pvar")
    output: "data/{prefix}.prune.in"
    shell: "plink2 --pfile data/{wildcards.prefix} --indep-pairwise 1000kb 0.01 --out data/{wildcards.prefix}"

rule pca:
    input: data = multiext("data/{prefix}", ".pgen", ".psam", ".pvar"), prune = "data/{prefix}.prune.in"
    output: "results/{prefix}.eigenvec"
    shell: "plink2 --pfile data/{wildcards.prefix} --extract {input.prune} --pca --out results/{wildcards.prefix}"

rule plot_pca:
    input: "results/{prefix}.eigenvec"
    output: "results/{prefix}_pca.png"
    shell: "Rscript code/plot_pcs.R {input} {output}"
