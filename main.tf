provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr_block

    tags = {
    Name = "${var.env_prefix}-VPC"
  }
}

resource "aws_subnet" "my_subnet" {                                             #Defining Subnet
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone

  tags = {
    Name = "${var.env_prefix}-Subnet"
  }
}

resource "aws_internet_gateway" "myapp-igw" {                                   # INTERNET-GATEWAY
    vpc_id = aws_vpc.my_vpc.id                                                                             
    tags = {
     Name = "${var.env_prefix}-Internet-Gateway"
  }
}

resource "aws_default_route_table" "Main-Route-Table" {                         # Default Route Table
    default_route_table_id = aws_vpc.my_vpc.default_route_table_id                                             

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    tags = {
    Name = "${var.env_prefix}-Main-Route-Table"
  }
 }


resource "aws_default_security_group" "myapp-Default-SG" {                      # Updating Default Inbound/Outbound Security Group
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = [var.my_ip] 
  }
   ingress {
    from_port        = 80                                                                           
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]                                                                 
  }
   egress {
    from_port        = 0                                                                           
    to_port          = 0
    protocol         = "-1"                                                                         
    cidr_blocks      = ["0.0.0.0/0"]                                                                
    prefix_list_ids = []                                                                            
  }
  tags = {
    Name = "${var.env_prefix}-Default-SG"
  }
}

data "aws_ami" "latest-amazon-linux-image" {                                        # Fetching Existing Linux AMI Details
    most_recent = "true"                                                                           
    owners = ["amazon"]                                                                             
    filter {                                                                                        
        name = "name"                                                                               
        values = [var.image_name]
    }
}

resource "aws_instance" "my_instance" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_default_security_group.myapp-Default-SG.id]
  availability_zone = var.avail_zone                                                             
  associate_public_ip_address = true
  key_name = var.key
  user_data = file("${path.module}/entry_script.sh")                                                                                                    
  user_data_replace_on_change = true 

  tags = {
        Name: "${var.env_prefix}-Server"                                                          
    }
}