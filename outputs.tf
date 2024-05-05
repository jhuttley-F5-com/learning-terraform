#output "instance_ami" {
#  value = aws_instance.web.ami
#}

output "pvc_id" {
  value = aws_vpc.my_vpc.id
}
#output "instance_arn" {
#  value = aws_instance.web.arn
#}
