#!/bin/bash
root_dir=`pwd`
groups=($(find . -type d -maxdepth 1 \( -not -name '.*' -and -not -name 'infra' \) | awk -F '/' '{print $2}'))
echo -e "\033[33mChoose project section:\033[0m"
iterator=0
for group in ${groups[@]}
do 
    echo "${iterator}.  ${group}"
    iterator=$(($iterator+1))
done
read tmp
if [[ $tmp =~ ^[0-9]+$ ]]
then 
    group=${groups[$tmp]}
else
    group=$tmp
fi
echo -e "\033[33mEnter lesson block number\033[0m"
read block_number
echo -e "\033[33mEnter lesson number\033[0m"
read lesson_number
tmp_name="lesson-${block_number}.${lesson_number}"
echo -e "\033[34mStarting create lesson \033[35m${tmp_name}\033[34m in cource section \033[35m${group}\033[0m"
git checkout master 
git pull
echo -e "\033[34mCreating git branch\033[0m"
git switch -c $tmp_name
echo -e "\033[34mCreating terraform template\033[0m"
mkdir -p $group/$tmp_name/terraform
export lesson_name=$(echo $tmp_name | tr "-" "_" | tr "." "_")
for file in $(ls $root_dir/infra/terraform/templates/*.tf)
do 
    echo "Templating $(basename $file)"
    cat $file | envsubst > $root_dir/$group/$tmp_name/terraform/$(basename $file)
done
echo -e "\033[34mChecking terraform installation\033[0m"
cd ${group}/${tmp_name}/terraform
source $root_dir/infra/terraform/.env.sh
terraform init > /dev/null && terraform plan > /dev/null
if [ $? != 0 ] 
then 
    echo -e "\033[31mTerraform planning failed\033[0m"
    exit -1
fi
echo -e "\033[32mTerraform init and plan - OK!\033[0m"
echo -e "\033[34mCreating ${tmp_name}.md file\033[0m"
touch  $root_dir/$group/$tmp_name/$(echo $tmp_name | tr "." "-").md
echo -e "\033[33mDo you want to deploy eve-ng on created vm?\033[0m"
read deploy_eve
if [[ $(echo $deploy_eve | tr [:lower:] [:upper:]) == "YES" || $(echo $deploy_eve | tr [:lower:] [:upper:]) == "Y" ]]
then 
    echo -e "\033[34mChanging centos image ....\033[0m"
    sed -i '' 's/image_id        = "fd8ad4ie6nhfeln6bsof"/image_id        = "fd8kdq6d0p8sij7h5qe3"/g' variables.tf
    echo -e "\033[34mChanging centos ssh user ....\033[0m"
    sed -i '' '/instances = var.instances/a\
    ssh_user = "ubuntu"\
    ' main.tf
    echo -e "\033[34mChanging vm \033[35mCPU\033[34m count ....\033[0m"
    sed -i '' 's/cpu             = 2/cpu             = 4/' variables.tf
    echo -e "\033[34mChanging vm \033[35mRAM\033[34m count ....\033[0m"
    sed -i '' 's/ram             = 1/ram             = 8/' variables.tf
    echo -e "\033[34mChanging vm \033[35mBOOT DISK\033[34m size ....\033[0m"
    sed -i '' '/ram             = 8/a\
                boot_disk_size             = 100\
    ' variables.tf
	echo -e "\033[34mDeploying VM ....\033[0m"
	terraform apply --auto-approve > /dev/null
    if [[ $? == 0 ]] 
    then 
        echo -e "\033[32mVM deploied - OK!" 
    else
        exit -1
    fi
    echo -e "\033[34mWaiting sshd started ....\033[0m"
    host=$(terraform output -json| jq -r '.instance_ip.value[0]')
    while [[ -z $(timeout 2s nc $host 22 | grep "SSH") ]]
    do
        echo "Still waiting ssh on host - $host"
        sleep 2
    done
    echo -e "\033[32mHost $host - OK!\033[0m"
	echo -e "\033[34mInstalling eve-ng ....\033[0m"
	ansible-playbook -i ../../../infra/ansible/inventory/hosts.ini ../../../infra/ansible/eve-ng.yml
fi