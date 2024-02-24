###################
# AWS VPC Creations
###################
resource "aws_vpc" "wordpress-vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = "true" #gives you an internal domain name
    enable_dns_hostnames = "true" #gives you an internal host name
    instance_tenancy = "default"    
    
    tags = {
        Name = "wordpress-vpc"
    }
}

######################
# AWS Subnet Creations
######################
resource "aws_subnet" "wordpress-subnet-public-1" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"
    cidr_block = var.vpc_cidr_spub1
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1c"
    tags = {
        Name = "wordpress-subnet-public-1"
    }
}

resource "aws_subnet" "wordpress-subnet-public-2" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"
    cidr_block = var.vpc_cidr_spub2
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1c"
    tags = {
        Name = "wordpress-subnet-public-2"
    }
}

resource "aws_subnet" "wordpress-subnet-public-3" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"
    cidr_block = var.vpc_cidr_spub3
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1c"
    tags = {
        Name = "wordpress-subnet-public-3"
    }
}

resource "aws_subnet" "wordpress-subnet-private-1" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"
    cidr_block = var.vpc_cidr_spri1
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1a"
    tags = {
        Name = "wordpress-subnet-private-1"
    }
}

resource "aws_subnet" "wordpress-subnet-private-2" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"
    cidr_block = var.vpc_cidr_spri2
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1b"
    tags = {
        Name = "wordpress-subnet-private-2"
    }
}

resource "aws_subnet" "wordpress-subnet-private-3" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"
    cidr_block = var.vpc_cidr_spri3
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1b"
    tags = {
        Name = "wordpress-subnet-private-3"
    }
}

###################
# AWS IGW Creation
###################
resource "aws_internet_gateway" "wordpress_igw" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"
    tags = {
        Name = "wordpress_igw"
    }
}

###################
# AWS RT Creations
###################
resource "aws_route_table" "wordpress-rt" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.wordpress_igw.id}" 
    }
    
    tags = {
        Name = "wordpress-rt"
    }
}

resource "aws_route_table_association" "wordpress-crta-public-subnet-1"{
    subnet_id = "${aws_subnet.wordpress-subnet-public-1.id}, ${aws_subnet.wordpress-subnet-public-2.id}, ${aws_subnet.wordpress-subnet-public-3.id}"
    route_table_id = "${aws_route_table.wordpress-rt.id}"
}

######################
# Wordpress SG Creation
#######################
resource "aws_security_group" "wordpress-sg" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"
    description = "Allow HTTP/HTTPS/SSH traffic"

    egress  {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress  {
        from_port = var.ingress_ports_ssh
        to_port = var.ingress_ports_ssh
        protocol = "tcp"
        // This means, all ip address are allowed to ssh ! 
        // Do not do it in the production. 
        // Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress  {
        from_port = var.ingress_ports_https
        to_port = var.ingress_ports_https
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    //If you do not add this rule, you can not reach the Wordpress  
    ingress {
        from_port = var.ingress_ports_http
        to_port = var.ingress_ports_http
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "wordpress-sg"
    }
}

#################
# RDS SG Creation
#################
resource "aws_security_group" "rds-sg" {
    vpc_id = "${aws_vpc.wordpress-vpc.id}"
    description = "Allow MySQL traffic from wordpress-sg"

    ingress  {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = [aws_security_group.wordpress-sg.id]
    }

    tags = {
        Name = "rds-sg"
    }
}

#########################
# Wordpress EC2 Creations
#########################
resource "aws_instance" "wordpress-ec2" {
    ami = var.ami_id
    instance_type = var.ec2_type
    key_name      = aws_key_pair.ssh_key.key_name
    # VPC
    subnet_id = "${aws_subnet.wordpress-subnet-public-1.id}"
    # Security Group
    vpc_security_group_ids = ["${aws_security_group.wordpress-sg.id}"]
    # Wordpress installation
    user_data = "${file("init-script.sh")}"
    tags = {
        Name = "wordpress-ec2"
    }
}

#########################
# MYSQL EC2 Creations
#########################
resource "aws_db_instance" "mysql" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro"
  identifier             = "mydb"
  username               = "admin"
  password               = "adminadmin"
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.aws_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  skip_final_snapshot    = true

  tags = {
    Name = "mysql"
  }
}

resource "aws_db_subnet_group" "aws_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.wordpress-subnet-private-1.id, aws_subnet.wordpress-subnet-private-2.id, aws_subnet.wordpress-subnet-private-3.id]

  tags = {
    Name = "My DB Subnet Group"
  }
}

########################
# AWS Key Pair Creations
########################
resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh-key"
  public_key = var.ssh_key_pub
}

output "VPCIP" {
    value = aws_vpc.wordpress-vpc.id
}

output "PubSubID1" {
    value = aws_subnet.wordpress-subnet-public-1.id
}

output "PubSubID2" {
    value = aws_subnet.wordpress-subnet-public-2.id
}

output "PubSubID3" {
    value = aws_subnet.wordpress-subnet-public-3.id
}

output "PrivateSubID1" {
    value = aws_subnet.wordpress-subnet-private-1.id
}

output "PrivateSubID2" {
    value = aws_subnet.wordpress-subnet-private-2.id
}

output "PrivateSubID3" {
    value = aws_subnet.wordpress-subnet-private-3.id
}

output "MyEC2PublicIP" {
    value = aws_instance.wordpress-ec2.public_ip
}

output "WordpressSGID" {
    value = aws_security_group.wordpress-sg.id
}

output "MYSQLSGID" {
    value = aws_security_group.rds-sg.id
}
