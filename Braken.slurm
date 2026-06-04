#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=12:00:00
#SBATCH --mem=16G
#SBATCH --array=1-N
#SBATCH --partition=cpu2023,cpu2022,cpu2019,cpu2021
#SBATCH --mail-user=paula.acostaamador@ucalgary.ca
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --job-name=bracken

source /work/parkins_lab/.bashrc
conda activate /work/parkins_lab/software/miniconda/envs/bracken

mkdir -p bracken

BASE="/work/parkins_lab/project/Nicole/Sequencing2026" #
LIST="${BASE}/samples_list.txt"
SAMPLE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$LIST")

bracken -d /work/parkins_lab/conda_envs/db/ \
  -i ${SAMPLE}.report \
  -o bracken/${SAMPLE}.bracken \
  -w bracken/${SAMPLE}.breport \
  -r 100 \
  -l S \
  -t 10
