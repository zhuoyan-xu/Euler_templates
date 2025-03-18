# Euler_templates

### Usage
Test base submit file
```bash
sbatch te.sh
```

Standard submit using py
```bash
python submit_euler.py -b run.sh -ng 4
```

submit multiple jobs using slurm job array id, inside `multiple`
```bash
sbatch --array=1-4 jobArray.sh
```
