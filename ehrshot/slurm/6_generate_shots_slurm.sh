#!/bin/bash
#SBATCH --job-name=4_eval
#SBATCH --output=logs/job_%A.out
#SBATCH --error=logs/job_%A.err
#SBATCH --time=2-00:00:00
#SBATCH --partition=nigam-a100
#SBATCH --mem=150G
#SBATCH --cpus-per-task=10
#SBATCH --gres=gpu:1
#SBATCH --exclude=secure-gpu-1,secure-gpu-2,secure-gpu-3

labeling_functions=(
    "guo_los" 
    "guo_readmission"
    "guo_icu"
    "new_hypertension"
    "new_hyperlipidemia"
    "new_pancan"
    "new_celiac"
    "new_lupus"
    "new_acutemi"
    "lab_thrombocytopenia"
    "lab_hyperkalemia"
    "lab_hypoglycemia"
    "lab_hyponatremia"
    "lab_anemia"
    "chexpert"
)
shot_strats=("few" "long")

# Iterate over labeling_functions
for labeling_function in "${labeling_functions[@]}"; do

    # Iterate over shot_strats
    for shot_strat in "${shot_strats[@]}"; do
    python3 6_generate_shot.py \
        --path_to_data ../EHRSHOT_ASSETS \
        --labeling_function ${labeling_function} \
        --num_replicates 1 \
        --path_to_save ../EHRSHOT_ASSETS/benchmark \
        --shot_strat ${shot_strat}
    done
done