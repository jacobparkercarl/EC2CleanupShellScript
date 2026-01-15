# EC2CleanupShellScript
## Usage
This is a simple script that you can upload into CloudShell, alongside a CSV file with headers for instance-id and region (see example in repo).

To run, upload both files into your cloudshell, run a chmod +x on the Cleanup script, and then run with a ./Cleanup.sh.

## Features
There is a "Dry Run" paramater that can be set to false to see what instances would be terminated when running. Change this to true to run and actually terminate instances.

## Other Notes
If any of your instances have volumes beyond the root volume this wont delete those. If you have termination protection enabled this script also wont work.
