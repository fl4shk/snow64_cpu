#!/bin/bash

remote_dir=$(/home/fl4shk/local/bin/extra/__careful__get_svformal_git_dirname_from_pwd.py)

scp generated_single_source_files/snow64_cpu.sv beta.symbioticeda.com:$remote_dir
