#!/bin/sh
cd ~/Dev

echo "Enter App Name"
read app_name

mkdir $app_name
cd $app_name

gh repo clone abdugaffor-abdurahimov/type-node-starter .

rm -rf README.md
rm -rf .git

npm i
git init

echo "# $app_name" >> README.md

echo "Description"
read description

gh repo create $app_name -y -d "$description" --public

git add .
git commit -m "first commit"
git branch -M main
git push -u origin main

code .
