resource=$1
while read -r region
do
	if [[ $resource == "ec2" ]]; then
		instance_ids=($(aws ec2 --region=$region describe-instances --query "Reservations[].Instances[].InstanceId[]" --output text))
		if [ -z "$instance_ids" ]; then
			echo -e "Nenhuma ${resource} para remover em ${region}"  
		else
			for instance_id in "${instance_ids[@]}"
			do
				echo -e "Removendo ${resource} em ${region}"
				aws ec2 --region=$region modify-instance-attribute --instance-id $instance_id --no-disable-api-termination
				result=$(aws ec2 --region=$region terminate-instances --instance-ids $instance_id 2>&1)
				if [ -z "$result" ]; then
					echo -e "${resource} removida com sucesso em ${region}"
				else
					echo "${resource} não removido. Erro: ${result}"
				fi
			done
		fi
	fi

	if [[ $resource == "subnet" ]]; then
		subnet_ids=($(aws ec2 --region=$region describe-subnets --query "Subnets[].SubnetId[]" --output text))
		if [ -z "$subnet_ids" ]; then
			echo -e "Nenhuma ${resource} para remover em ${region}"  
		else
			for subnet_id in "${subnet_ids[@]}"
			do
				echo -e "Removendo ${resource} em ${region}"
				result=$(aws ec2 --region=$region delete-subnet --subnet-id $subnet_id 2>&1)
				if [ -z "$result" ]; then
					echo -e "${resource} removida com sucesso em ${region}"
				else
					echo "${resource} não removido. Erro: ${result}"
				fi
			done
		fi
	fi

	if [[ $resource == "sg" ]]; then
		sg_ids=($(aws ec2 --region=$region describe-security-groups --query "SecurityGroups[].GroupId[]" --output text))
		if [ -z "$sg_ids" ]; then
			echo -e "Nenhuma ${resource} para remover em ${region}"  
		else
			for sg_id in "${sg_ids[@]}"
			do
				echo -e "Removendo ${resource} em ${region}"
				result=$(aws ec2 --region=$region delete-security-group --group-id $sg_id 2>&1)
				if [ -z "$result" ]; then
					echo -e "${resource} removida com sucesso em ${region}"
				else
					echo "${resource} não removido. Erro: ${result}"
				fi
			done
		fi
	fi

	if [[ $resource == "vpc" ]]; then
		vpc_ids=($(aws ec2 --region=$region describe-vpcs --query "Vpcs[].VpcId[]" --output text))
		if [ -z "$vpc_ids" ]; then
			echo -e "Nenhuma ${resource} para remover em ${region}"  
		else
			for vpc_id in "${vpc_ids[@]}"
			do
				echo -e "Removendo ${resource} em ${region}"
				result=$(aws ec2 --region=$region delete-vpc --vpc-id $vpc_id 2>&1)
				if [ -z "$result" ]; then
					echo -e "${resource} removida com sucesso em ${region}"
				else
					echo "${resource} não removido. Erro: ${result}"
				fi
			done
		fi
	fi

	if [[ $resource == "nacl" ]]; then
		nacl_ids=($(aws ec2 --region=$region describe-network-acls --query "NetworkAcls[].NetworkAclId[]" --output text))
		if [ -z "$nacl_ids" ]; then
			echo -e "Nenhuma ${resource} para remover em ${region}"  
		else
			for nacl_id in "${nacl_ids[@]}"
			do
				echo -e "Removendo ${resource} em ${region}"
				result=$(aws ec2 --region=$region delete-network-acl --network-acl-id $nacl_id 2>&1)
				if [ -z "$result" ]; then
					echo -e "${resource} removida com sucesso em ${region}"
				else
					echo "${resource} não removido. Erro: ${result}"
				fi
			done
		fi
	fi

	if [[ $resource == "rtb" ]]; then
		rtb_ids=($(aws ec2 --region=$region describe-route-tables --query "RouteTables[].RouteTableId[]" --output text))
		if [ -z "$rtb_ids" ]; then
			echo -e "Nenhuma ${resource} para remover em ${region}"  
		else
			for rtb_id in "${rtb_ids[@]}"
			do
				echo -e "Removendo ${resource} em ${region}"
				result=$(aws ec2 --region=$region delete-route-table --route-table-id $rtb_id 2>&1)
				if [ -z "$result" ]; then
					echo -e "${resource} removida com sucesso em ${region}"
				else
					echo "${resource} não removido. Erro: ${result}"
				fi
			done
		fi
	fi

	if [[ $resource == "vpce" ]]; then
		vpce_ids=($(aws ec2 --region=$region describe-vpc-endpoints --query "VpcEndpoints[].VpcEndpointId" --output text))
		if [ -z "$vpce_ids" ]; then
			echo -e "Nenhuma ${resource} para remover em ${region}"  
		else
			for vpce_id in "${vpce_ids[@]}"
			do
				echo -e "Removendo ${resource} em ${region}"
				result=$(aws ec2 --region=$region delete-vpc-endpoints --vpc-endpoint-ids $vpce_id 2>&1)
				if [ -z "$result" ]; then
					echo -e "${resource} removida com sucesso em ${region}"
				else
					echo "${resource} não removido. Erro: ${result}"
				fi
			done
		fi
	fi

	if [[ $resource == "dopt" ]]; then
		dopt_ids=($(aws ec2 --region=$region describe-dhcp-options --query "DhcpOptions[].DhcpOptionsId" --output text))
		if [ -z "$dopt_ids" ]; then
			echo -e "Nenhuma ${resource} para remover em ${region}"  
		else
			for dopt_id in "${dopt_ids[@]}"
			do
				echo -e "Removendo ${resource} em ${region}"
				result=$(aws ec2 --region=$region delete-dhcp-options --dhcp-options-id $dopt_id 2>&1)
				if [ -z "$result" ]; then
					echo -e "${resource} removida com sucesso em ${region}"
				else
					echo "${resource} não removido. Erro: ${result}"
				fi
			done
		fi
	fi

	if [[ $resource == "igw" ]]; then
		igw_ids=($(aws ec2 --region=$region describe-internet-gateways --query "InternetGateways[].[InternetGatewayId]" --output text))
		vpc_ids=($(aws ec2 --region=$region describe-internet-gateways --query "InternetGateways[].[Attachments[].VpcId]" --output text))
		
		if [ -z "$igw_ids" ]; then
			echo -e "Nenhuma ${resource} para remover em ${region}"  
		else
			for ((i=0; i<${#igw_ids[@]};i++))
			do
				echo -e "Desatachando ${resource} em ${region}"
				result=$(aws ec2 --region=$region detach-internet-gateway --internet-gateway-id ${igw_ids[i]} --vpc-id ${vpc_ids[i]} 2>&1)
				if [ -z "$result" ]; then
					echo -e "${resource} desatachado com sucesso em ${region}"
				else
					echo "${resource} não desatachado. Erro: ${result}"
				fi

				echo -e "Removendo ${resource} em ${region}"
				result=$(aws ec2 --region=$region delete-internet-gateway --internet-gateway-id ${igw_ids[i]} 2>&1)
				if [ -z "$result" ]; then
					echo -e "${resource} removido com sucesso em ${region}"
				else
					echo "${resource} não removido. Erro: ${result}"
				fi
			done
		fi
	fi
	
done < regions.txt
