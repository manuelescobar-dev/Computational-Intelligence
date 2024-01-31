# Python Environment
Instructions to set up the python environment for a project.

## Setup
1. Install [Anaconda](https://www.anaconda.com/products/individual)
2. Create a new environment with the required packages
```bash
conda create --name <env_name> --file requirements.txt
```
3. Activate the environment
```bash
conda activate <env_name>
```
4. Install the environment as a kernel for Jupyter
```bash
python -m ipykernel install --user --name=<env_name>
```
5. Open Jupyter and select the kernel
```bash
jupyter notebook
```
6. To deactivate the environment
```bash
conda deactivate
```

## Update
1. Activate the environment
```bash
conda activate <env_name>
```
2. Update the environment
```bash
conda update --all
```
3. Update the environment as a kernel for Jupyter
```bash
python -m ipykernel install --user --name=<env_name>
```
4. To deactivate the environment
```bash
conda deactivate
```