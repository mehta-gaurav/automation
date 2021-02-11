#!/bin/sh

repoBaseFolder=/Users/gauravmehta/Repository/architecture-diagram/code
prBranchBaseFolder=/Users/gauravmehta/Repository/architecture-diagram/pr-branches

## Read the JIRA Assignment key
#echo "What is the assignment key"
#read assignmentKey

## Read the JIRA Assignment Code URL
echo "Please provide the repository URL"
read codeRepo

## Extract the Code Repository
repoName=$(echo $codeRepo | cut -d '/' -f 2 | cut -d '.' -f 1)
#echo $repoName

## Clone the Code repository, read Serverless.yml file for functions and open VS code
cd $repoBaseFolder
if [ -d "$repoName" ]; then
    echo "Repository $repoName already cloned. Taking updates"
    cd $repoName
    git pull
else
   echo "Cloning Repository $repoName"
   git clone $codeRepo
   cd $repoName
fi

## Check for serverless.yml
if [ -f "serverless.yml" ]; then
    echo "------------------SERVERLESS.YML---------------------------"
    ## Get firstline & lastline of required sections in serverless.yml
    firstLine=`grep -n "functions:" serverless.yml | cut -d : -f 1`
    firstLine=$(($firstLine + 1))

    lastLine=`grep -n "Resources:" serverless.yml | cut -d : -f 1`

    if [ -z "$lastLine" ]; then
	lastLine=`wc -l < serverless.yml`
    else
	lastLine=$(($lastLine - 1))
    fi

    ## Printing functions section of serverless.yml file
    sed -n "$firstLine","$lastLine"p serverless.yml
fi

## Check for requirements.txt/requirements-dev.txt
if [ -f "requirements.txt" ]; then
    echo "------------------Requirement------------------------------"
    ## Printing requirements.txt contents
    cat requirements.txt

    if [ -f "requirements-dev.txt" ]; then
	cat requirements-dev.txt
    fi
fi
echo ""
## Open VS Code with the current folder
code -n -a .
