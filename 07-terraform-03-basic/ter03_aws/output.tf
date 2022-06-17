
/*output "account_id" {
  value = data.aws_caller_identity.korsh-aws-caller.account_id
}


output "caller_user" {
  value = data.aws_caller_identity.korsh-aws-caller.user_id
}
*/ 
output "region" {
  value = data.aws_region.korsh-aws-region.name
}
 
output "instance_ip_addr" {
   value = aws_instance.web[*].private_ip
   #нужно создать заранее security group
   #depends_on = [
   #  aws_security_group_rule.local_access,
   #]
} 

output "subnet_id" {
   value = aws_instance.web[*].subnet_id
} 

