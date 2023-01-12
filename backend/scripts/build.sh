#!/bin/bash
path_cwd="/Users/harshanas/Documents/Work/Querious/tubesight"
output_dir="backend/build"
functions_dir="backend/functions"

echo "Building deployment packages for lambda functions..."
if [ -d $output_dir ]; then
    rmdir $output_dir
fi

mkdir $output_dir

cd $functions_dir

for function_name in *
do 
    current_dir=$path_cwd/$functions_dir/$function_name
    dest_dir=$path_cwd/$output_dir/$function_name
    env_dir=$current_dir/env_$function_name

    echo "Creating virtual environment for function: $function_name..."
    python3 -m venv $env_dir
    source $env_dir/bin/activate

    echo "Installing dependencies for function : $function_name..."
    python3 -m pip install -r $current_dir/requirements.txt

    deactivate

    mkdir $dest_dir
    cp -r $env_dir/lib/python3.10/site-packages/* $dest_dir
    rm -rf $env_dir
    cp -r $current_dir/* $dest_dir

done

