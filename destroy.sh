#!/bin/bash

resource=$1

echo "Escolha o recurso que deseja deletar:"
echo "1. EC2"
echo "2. VPC"
echo "3. IGW"
echo "4. SUBNET"
echo "5. SG"
echo "6. NACL"
echo "7. RTB"
echo "8. DOPT"
echo "9. VPCE"
echo "0. SAIR"
read opcao

case $opcao in

	1)
		while read -r region
		do
			instance_ids=($(aws ec2 --region=$region describe-instances --query "Reservations[].Instances[].InstanceId[]" --output text))
			if [ -z "$instance_ids" ]; then
				echo -e "Nenhuma EC2 para remover em ${region}"  
			else
				for instance_id in "${instance_ids[@]}"
				do
					echo -e "Removendo EC2 em ${region}"
					aws ec2 --region=$region modify-instance-attribute --instance-id $instance_id --no-disable-api-termination
					result=$(aws ec2 --region=$region terminate-instances --instance-ids $instance_id 2>&1)
					if [ -z "$result" ]; then
						echo -e "EC2 removida com sucesso em ${region}"
					else
						echo "EC2 não removido. Erro: ${result}"
					fi
				done
			fi
		done < regions.txt
		;;
	2)
		while read -r region
		do
			vpc_ids=($(aws ec2 --region=$region describe-vpcs --query "Vpcs[].VpcId[]" --output text))
			if [ -z "$vpc_ids" ]; then
				echo -e "Nenhuma VPC para remover em ${region}"  
			else
				for vpc_id in "${vpc_ids[@]}"
				do
					echo -e "Removendo VPC em ${region}"
					result=$(aws ec2 --region=$region delete-vpc --vpc-id $vpc_id 2>&1)
					if [ -z "$result" ]; then
						echo -e "VPC removida com sucesso em ${region}"
					else
						echo "VPC não removido. Erro: ${result}"
					fi
				done
			fi
		done < regions.txt
		;;
	3)
		while read -r region
		do
			igw_ids=($(aws ec2 --region=$region describe-internet-gateways --query "InternetGateways[].[InternetGatewayId]" --output text))
			vpc_ids=($(aws ec2 --region=$region describe-internet-gateways --query "InternetGateways[].[Attachments[].VpcId]" --output text))
			
			if [ -z "$igw_ids" ]; then
				echo -e "Nenhuma IGW para remover em ${region}"  
			else
				for ((i=0; i<${#igw_ids[@]};i++))
				do
					echo -e "Desatachando IGW em ${region}"
					result=$(aws ec2 --region=$region detach-internet-gateway --internet-gateway-id ${igw_ids[i]} --vpc-id ${vpc_ids[i]} 2>&1)
					if [ -z "$result" ]; then
						echo -e "IGW desatachado com sucesso em ${region}"
					else
						echo "IGW não desatachado. Erro: ${result}"
					fi

					echo -e "Removendo IGW em ${region}"
					result=$(aws ec2 --region=$region delete-internet-gateway --internet-gateway-id ${igw_ids[i]} 2>&1)
					if [ -z "$result" ]; then
						echo -e "IGW removido com sucesso em ${region}"
					else
						echo "IGW não removido. Erro: ${result}"
					fi
				done
			fi
		done < regions.txt
		;;
	4)
		while read -r region
		do
			subnet_ids=($(aws ec2 --region=$region describe-subnets --query "Subnets[].SubnetId[]" --output text))
			if [ -z "$subnet_ids" ]; then
				echo -e "Nenhuma SUBNET para remover em ${region}"  
			else
				for subnet_id in "${subnet_ids[@]}"
				do
					echo -e "Removendo SUBNET em ${region}"
					result=$(aws ec2 --region=$region delete-subnet --subnet-id $subnet_id 2>&1)
					if [ -z "$result" ]; then
						echo -e "SUBNET removida com sucesso em ${region}"
					else
						echo "SUBNET não removido. Erro: ${result}"
					fi
				done
			fi
		done < regions.txt
		;;
	5)
		while read -r region
		do
			sg_ids=($(aws ec2 --region=$region describe-security-groups --query "SecurityGroups[].GroupId[]" --output text))
			if [ -z "$sg_ids" ]; then
				echo -e "Nenhuma SG para remover em ${region}"  
			else
				for sg_id in "${sg_ids[@]}"
				do
					echo -e "Removendo SG em ${region}"
					result=$(aws ec2 --region=$region delete-security-group --group-id $sg_id 2>&1)
					if [ -z "$result" ]; then
						echo -e "SG removida com sucesso em ${region}"
					else
						echo "SG não removido. Erro: ${result}"
					fi
				done
			fi
		done < regions.txt
		;;
	6)
		while read -r region
		do
			nacl_ids=($(aws ec2 --region=$region describe-network-acls --query "NetworkAcls[].NetworkAclId[]" --output text))
			if [ -z "$nacl_ids" ]; then
				echo -e "Nenhuma NACL para remover em ${region}"  
			else
				for nacl_id in "${nacl_ids[@]}"
				do
					echo -e "Removendo NACL em ${region}"
					result=$(aws ec2 --region=$region delete-network-acl --network-acl-id $nacl_id 2>&1)
					if [ -z "$result" ]; then
						echo -e "NACL removida com sucesso em ${region}"
					else
						echo "NACL não removido. Erro: ${result}"
					fi
				done
			fi
		done < regions.txt
		;;
	7)
		while read -r region
		do
			rtb_ids=($(aws ec2 --region=$region describe-route-tables --query "RouteTables[].RouteTableId[]" --output text))
			if [ -z "$rtb_ids" ]; then
				echo -e "Nenhuma RTB para remover em ${region}"  
			else
				for rtb_id in "${rtb_ids[@]}"
				do
					echo -e "Removendo RTB em ${region}"
					result=$(aws ec2 --region=$region delete-route-table --route-table-id $rtb_id 2>&1)
					if [ -z "$result" ]; then
						echo -e "RTB removida com sucesso em ${region}"
					else
						echo "RTB não removido. Erro: ${result}"
					fi
				done
			fi
		done < regions.txt
		;;
	8)
		while read -r region
		do
			dopt_ids=($(aws ec2 --region=$region describe-dhcp-options --query "DhcpOptions[].DhcpOptionsId" --output text))
			if [ -z "$dopt_ids" ]; then
				echo -e "Nenhuma DOPT para remover em ${region}"  
			else
				for dopt_id in "${dopt_ids[@]}"
				do
					echo -e "Removendo DOPT em ${region}"
					result=$(aws ec2 --region=$region delete-dhcp-options --dhcp-options-id $dopt_id 2>&1)
					if [ -z "$result" ]; then
						echo -e "DOPT removida com sucesso em ${region}"
					else
						echo "DOPT não removido. Erro: ${result}"
					fi
				done
			fi
		done < regions.txt
		;;
	9)
		while read -r region
		do
			vpce_ids=($(aws ec2 --region=$region describe-vpc-endpoints --query "VpcEndpoints[].VpcEndpointId" --output text))
			if [ -z "$vpce_ids" ]; then
				echo -e "Nenhuma VPCE para remover em ${region}"  
			else
				for vpce_id in "${vpce_ids[@]}"
				do
					echo -e "Removendo VPCE em ${region}"
					result=$(aws ec2 --region=$region delete-vpc-endpoints --vpc-endpoint-ids $vpce_id 2>&1)
					if [ -z "$result" ]; then
						echo -e "VPCE removida com sucesso em ${region}"
					else
						echo "VPCE não removido. Erro: ${result}"
					fi
				done
			fi
		done < regions.txt
		;;
	0)
		exit
		;;
	*)
		echo "Opção inválida."
esac