
rule all:
    input: "results/all_varqc.eigenvec", expand("results/chr{c}_stats.txt", c = range(20, 23))

rule get_stats:
    input: "data/chr{c}.vcf.gz"
    output: "results/chr{c}_stats.txt"
    shell: "mkdir -p results; bcftools stats {input} > {output}"

rule combine_data:
    input: expand("data/chr{c}.vcf.gz", c = range(20, 23))
    output: "data/all.vcf.gz"
    shell: "bcftools concat -o {output} {input}"

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

