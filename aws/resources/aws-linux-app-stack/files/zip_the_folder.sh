#!/bin/bash

Curr=`pwd`

source=$1
filename=$2

echo "Source Path: $source"
echo "File Name: $filename"

echo "Navigate into source path.."
cd $source
echo
echo "Remove Old $filename from the folder.."
rm -rf *.zip

echo
echo "Zip all the files.."
zip -r $filename *

echo "List the files in source.."
echo
ls
