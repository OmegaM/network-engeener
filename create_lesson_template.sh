#!/bin/bash
root_dir=`pwd`
groups=($(find . -type d -maxdepth 1 \( -not -name '.*' -and -not -name 'infra' \) | awk -F '/' '{print $2}'))
echo -e "\033[32mChoose project section:\033[0m"
iterator=0
for group in ${groups[@]}
do 
    echo "${iterator}.  ${group}"
    iterator+=1
done
read tmp
if [[ $tmp =~ ^[0-9]+$ ]]
then 
    group=${groups[$tmp]}
else
    group=$tmp
fi
echo -e "\033[32mEnter lesson template name\033[0m"
read tmp_name
echo -e "\033[32mStarting create lesson \033[35m${tmp_name}\033[32m in cource section \033[35m${group}\033[0m"
git checkout master 
git pull
echo -e "\033[32mCreating git branch\033[0m"
git switch -c $tmp_name
echo -e "\033[32mCreating terraform template\033[0m"
mkdir -p $group/$tmp_name/terraform
export lesson_name=$(echo $tmp_name | tr "-" "_" | tr "." "_")
for file in $(ls $root_dir/infra/terraform/templates/*.tf)
do 
    echo "Templating $(basename $file)"
    cat $file | envsubst > $root_dir/$group/$tmp_name/terraform/$(basename $file)
done
echo -e "\033[32mChecking terraform installation\033[0m"
cd ${group}/${tmp_name}/terraform
source $root_dir/infra/terraform/.env.sh
terraform init && terraform plan
if [ $? != 0 ] 
then 
    echo -e "\033[31mTerraform planning failed\033[0m"
fi
echo -e "\033[32mCreating ${tmp_name}.md file\033[0m"
touch  $root_dir/$group/$tmp_name/$(echo $tmp_name | tr "." "-").md