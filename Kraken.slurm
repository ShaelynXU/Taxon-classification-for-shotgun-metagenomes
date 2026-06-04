#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --time=6:00:00
#SBATCH --mem=128G
#SBATCH --partition=cpu2023,cpu2022,cpu2019
#SBATCH --mail-user=@ucalgary.ca
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --array=1-N #
#SBATCH --job-name=kraken

module load conda
conda activate kraken_env #

mkdir -p kraken

BASE="/work/parkins_lab/project/"#
LIST="${BASE}/samples_list.txt"
SAMPLE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$LIST")

kraken2 --db /work/parkins_lab/conda_envs/db/ \
  --threads 24 \
  --report kraken/${SAMPLE}.report \
  --report-minimizer-data \
  --paired \
  --minimum-hit-groups 3 \
  --gzip-compressed \
  ${SAMPLE}/${SAMPLE}_1_paired_kneaddata_paired_1.fastq.gz \
  ${SAMPLE}/${SAMPLE}_1_paired_kneaddata_paired_2.fastq.gz \
  > kraken/${SAMPLE}.kraken2
