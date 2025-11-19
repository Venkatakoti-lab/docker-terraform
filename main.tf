resource "aws_instance" "docker" {
  ami = data.aws_ami.web.id
  instance_type = "t3.medium"
  vpc_security_group_ids = [ aws_security_group.allow_docker.id ]
  #for this project 20GB is not sufficient so i can take it as 50GB
  root_block_device{
    volume_size = 50
    volume_type = "gp3"
  }
  user_data = file("docker.sh")
  tags = {
    Name= "docker"
  }
}
resource "aws_security_group" "allow_docker" {
  name= "allow_allo_docker"
  description = "Allow TLS inbound traffic and all outbound traffic"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp" 
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp" 
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  tags = {
    Name= "docker_sg"
  }
}