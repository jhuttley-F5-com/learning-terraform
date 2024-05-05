#output "instance_ami" {
#  value = aws_instance.web.ami
#}

output "instance_ami" {
value = data.aws_ami.app_ami.id

}

output "pvc_id" {
  value = aws_vpc.my_vpc.id
}
#output "instance_arn" {
#  value = aws_instance.web.arn
#}
