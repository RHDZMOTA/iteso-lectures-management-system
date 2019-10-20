# ITESO Lectures - Management System

This repo contains some utility scripts to manage homeworks, classwork, exams, etc.

## Setup

Download this repository and the submodules: 

```commandline
$ git clone --recurse-submodules git@github.com:RHDZMOTA/iteso-lectures-management-system.git
```

Install dependencies: 

* Bash tools.
    * [jq](https://stedolan.github.io/jq/): `sudo apt install jq`
    * [curl](https://curl.haxx.se/): `sudo apt install curl`
* Python 3 or superior.
    * [python](https://www.python.org/): `sudo apt install python3`

## Usage 

The `manage.sh` script automatically creates git-submodules for each class repository and student. 
Environment variables are used for configuration of the target repositories. 

### Config File

Create the config file with the following command: 

```commandline
$ bash manage.sh --create-config 201902
```

This will create a `.env.201902` file with the name of the repositories that should be used during the class. 

**Note** you have to manually create/populate the repositories. 

### Sync main repo

Getting in sync with the main repo: 

```commandline
$ env $(cat .env.201902) bash manage.sh --main
```

By using pre-pending `env $(cat .env.201902)` to the command, you provide an specific set of env-variables to the script.

### Sync exams

Getting in sync with the exam's repositories: 

```commandline
$ env $(cat .env.201902) bash manage.py --exam --first
```

Options:

```text
    --first     : Sync first exam.
    --second    : Sync second exam.
    --third     : Sync third exam.
```

