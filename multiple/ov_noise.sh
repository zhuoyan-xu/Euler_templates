#!/bin/bash

tasks=videomme
# model_id=lmms-lab/llava-onevision-qwen2-0.5b-ov
model_id=lmms-lab/llava-onevision-qwen2-7b-ov
# Base output directory

output_dir="./logs/ov/videomme"
echo "Running evaluation with noise type: $noise_type"

# Create a specific output directory for this noise type
noise_output_dir="$output_dir/$noise_type"
mkdir -p "$noise_output_dir"

# Run the evaluation command
python3 -m accelerate.commands.launch \
    -m src.eval \
    --model noise_llava_onevision \
    --model_args pretrained=$model_id,conv_template=qwen_1_5,model_name=llava_qwen,noise=$noise_type \
    --tasks $tasks \
    --batch_size 1 \
    --log_samples \
    --log_samples_suffix llava_$noise_type \
    --output_path="$noise_output_dir" 
echo "Completed evaluation for noise type: $noise_type"
