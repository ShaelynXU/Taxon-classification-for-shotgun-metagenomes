#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem=8G
#SBATCH --partition=cpu2023,cpu2022,cpu2019,cpu2021
#SBATCH --job-name=combine_bracken

source /work/parkins_lab/.bashrc
conda activate /work/parkins_lab/software/miniconda/envs/bracken

BASE="/work/parkins_lab/project/Nicole/Sequencing2026" #####change the bracken output folder
cd "$BASE" || exit 1

python /work/parkins_lab/conda_envs/bracken_scripts/combine_bracken_outputs.py \
  --files $(ls "${BASE}"/*.bracken | sort) \
  -o bracken_counts_all.tsv
