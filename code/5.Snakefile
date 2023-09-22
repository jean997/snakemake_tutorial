configfile: "5.config.yaml"

rule all:
    input: "results/all_varqc_pca.png", expand("results/chr{c}_stats.txt", c = range(20, 23))

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
    params: geno_thresh = config["QC"]["geno_thresh"], 
            qual_thresh = config["QC"]["qual_thresh"], 
            maf = config["QC"]["maf"]
    shell: """
           plink2 --vcf {input} --set-missing-var-ids '@:#' --snps-only \
                 --var-min-qual {params.qual_thresh} \
                 --geno {params.geno_thresh} \
                 --maf {params.maf} \
                 --make-pgen \
                 --out data/all_varqc 
          """

rule ld_prune:
    input: multiext("data/{prefix}", ".pgen", ".psam", ".pvar")
    output: "data/{prefix}.prune.in"
    params: kb = config["LD"]["kb"], r2 = config["LD"]["r2"]
    shell: """
          plink2 --pfile data/{wildcards.prefix} \
          --indep-pairwise {params.kb} {params.r2} \
          --out data/{wildcards.prefix}
          """

rule pca:
    input: data = multiext("data/{prefix}", ".pgen", ".psam", ".pvar"), prune = "data/{prefix}.prune.in"
    output: "results/{prefix}.eigenvec"
    shell: "plink2 --pfile data/{wildcards.prefix} --extract {input.prune} --pca --out results/{wildcards.prefix}"

rule plot_pca:
    input: "results/{prefix}.eigenvec"
    output: "results/{prefix}_pca.png"
    shell: "Rscript code/plot_pcs.R {input} {output}"
