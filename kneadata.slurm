#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=08:00:00
#SBATCH --mem=40G
#SBATCH --partition=cpu2021
#SBATCH --array=1-29%10
#SBATCH --output=kneaddata_log/kneaddata_%A_%a.out
#SBATCH --error=kneaddata_log/kneaddata_%A_%a.err
#SBATCH --mail-user=zhaohuishaelyn.xu@ucalgary.ca
#SBATCH --mail-type=ALL
#SBATCH --job-name=kneaddata

module load conda
conda activate bowtie2  #replace with your environment bfsfsjkdhfjhdfj

BASE="/work/parkins_lab/project/Shaelyn/wastewater_amr"  # the base folder directory
READS="${BASE}/03.TrimmedData" # the folder has your trimmed data
OUT="${BASE}/kneaddata_out_2" #the folder for your output
DB="/work/parkins_lab/project/Shaelyn/human_genome_db"
LIST="${BASE}/kneadata_list.txt" # the path to have your sample list, one sample per line

mkdir -p kneaddata_log_2 "${OUT}"

# Get sample name from the Nth line of the list
SAMPLE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$LIST")

# Safety checks
if [ -z "$SAMPLE" ]; then
  echo "ERROR: No sample found for task id ${SLURM_ARRAY_TASK_ID} in $LIST"
  exit 1
fi

R1="${READS}/${SAMPLE}_1_paired.fq.gz"
R2="${READS}/${SAMPLE}_2_paired.fq.gz" #check the naming of your sample

if [ ! -f "$R1" ] || [ ! -f "$R2" ]; then
  echo "ERROR: Missing input files:"
  echo "  $R1"
  echo "  $R2"
  exit 1
fi

echo "Running kneaddata for $SAMPLE"
echo "R1: $R1"
echo "R2: $R2"

kneaddata \
  --input1 "$R1" \
  --input2 "$R2" \
  -db "$DB" \
  --output "${OUT}/${SAMPLE}" \
  --threads 8 \
  --bypass-trim \
  --bypass-trf
