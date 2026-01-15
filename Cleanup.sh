#!/usr/bin/env bash
# jacobparkercarl
# 1.14.2026
# Cleans up EC2 instances listed in a CSV file.
set -euo pipefail

CSV="WhateverYourFileName.csv"
DRY_RUN="true"   # Set to false to run for real
CHUNK=50         # Number of instances to delete per API call

declare -A BY_REGION=()

# Read CSV
while IFS=, read -r instance_id region; do
  [[ "${instance_id}" == "InstanceId" || -z "${instance_id}" ]] && continue

  # Trim quotes / CRLF just in case cause it always bytes me
  instance_id="${instance_id//\"/}"; instance_id="${instance_id//$'\r'/}"
  region="${region//\"/}"; region="${region//$'\r'/}"

  BY_REGION["$region"]+="${instance_id} "
done < "${CSV}"

# Terminate instances
for region in "${!BY_REGION[@]}"; do
  echo "Region: ${region}"
  read -r -a IDS <<< "${BY_REGION[$region]}"

  for ((i=0; i<${#IDS[@]}; i+=CHUNK)); do
    slice=("${IDS[@]:i:CHUNK}")

    if [[ "${DRY_RUN}" == "true" ]]; then
      echo "DRY RUN: would terminate: ${slice[*]}"
    else
      aws ec2 terminate-instances \
        --region "${region}" \
        --instance-ids "${slice[@]}"
      echo "Terminated: ${slice[*]}"
    fi
  done
  echo
done

echo "Woohoo Done."
