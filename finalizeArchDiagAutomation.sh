#!/bin/sh

prBranchBaseFolder=/Users/gauravmehta/Repository/architecture-diagram/pr-branches

## Read the JIRA Assignment key
echo "What is the assignment key"
read assignmentKey

## Read the JIRA Assignment Summary
echo "What is the JIRA Assignment Summary"
read assignmentSummary

cd $prBranchBaseFolder
## Clone the rc-pca Master folder, Create new branch and make default commit if the repository doesn't exists
if [ ! -d "rc-pca-$assignmentKey" ]; then
    git clone git@github.com:mehta-gaurav/rc-pca-gauravmehta-RemoteU-System.git rc-pca-$assignmentKey
    cd rc-pca-$assignmentKey
    > api.yaml
    > C4diagrams.yaml
    git checkout -b $assignmentKey
    git add *.yaml
    git commit -m "Default branch commit"
    git push --set-upstream origin $assignmentKey
else
    cd rc-pca-$assignmentKey
    > api.yaml
    > C4diagrams.yaml
fi

## Move the Structurizr workspace JSON file, convert to YAML and commit
mv /Users/gauravmehta/Downloads/structurizr-62815-workspace.json finalDiag.json
json2yaml finalDiag.json > C4diagrams.yaml
git add C4diagrams.yaml
git commit -m "Updating Diagram"

if [ -f "/Users/gauravmehta/Downloads/api.json" ]; then
    ## Move the API JSON file, convert to YAML and commit
    mv /Users/gauravmehta/Downloads/api.json api.json
    json2yaml api.json > api.yaml
    git add api.yaml
    git commit -m "Adding API changes"
fi

## Pushing changes to branch
git push

echo "------------------PR SUMMARY-------------------------------"
echo "$assignmentKey - $assignmentSummary"
echo ""
echo "Functional Overview: <TBD>"
echo ""
echo "C4 Component View: <TBD>"
echo ""
echo "System API: https://docs.google.com/document/d/1__fQzjsPltgs6fIxsakId6IO_9fV4nLvU_B045OIkIA/edit#heading=h.lrcbds93pjc5"
echo ""
echo "Data View section: <TBD>"
echo ""
echo "3rd Party Software: https://docs.google.com/document/d/1__fQzjsPltgs6fIxsakId6IO_9fV4nLvU_B045OIkIA/edit#heading=h.llg71pa2hxyy"
