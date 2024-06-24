resource "aws_security_group" "sg_allow_ssh" {
  name        = "sg_allow_ssh"
  description = "Allow all in and all out"
  vpc_id = var.vpc_id

ingress { # Egress all allow
    description = "Ingress allow"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

egress { # Egress all allow
    description = "Egress allow"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_allow_ssh"
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_security_group" "sg_basic_web_80" {
  name        = "sg_basic_web_80"
  description = "Allows Port 22, 80, and 6788 for elastic"
  vpc_id = var.vpc_id

  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]
  }

  ingress {
    description      = "Allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]
  }

  ingress {
    description      = "Allow Elastic"
    from_port        = 6788
    to_port          = 6788
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress { # Egress all allow
    description = "Egress allow"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_basic_web_80"
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_security_group" "sg_basic_docker_swarm" {
  name        = "sg_basic_docker_swarm"
  description = "Allows Docker Swarm"
  vpc_id = var.vpc_id

  # Docker Swarm Ports
  ingress {
    description      = "Communicating between manager and workers"
    from_port        = 2377
    to_port          = 2377
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]
  }

  ingress {
    description      = "TCP for overlay network node discovery"
    from_port        = 7946
    to_port          = 7946
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]
  }

  ingress {
    description      = "UDP for overlay network node discovery"
    from_port        = 7946
    to_port          = 7946
    protocol         = "udp"
    cidr_blocks      = [var.vpc_cidr_block]
  }

  ingress {
    description      = "Overlay network traffic"
    from_port        = 4789
    to_port          = 4789
    protocol         = "udp"
    cidr_blocks      = [var.vpc_cidr_block]
  }

  ingress {
    description      = "IPSec ESP for overlay network with encryption"
    from_port        = 50
    to_port          = 50
    protocol         = "udp"
    cidr_blocks      = [var.vpc_cidr_block]
  }

  egress { # Egress all allow
    description = "Egress allow"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_basic_docker_swarm"
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_security_group" "sg_basic_web_8080" {
  name        = "sg_basic_web_8080"
  description = "Allows Port 22, 80, 443, and 6788 for elastic"
  vpc_id = var.vpc_id

  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]
  }

  ingress {
    description      = "Allow HTTP"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]
  }

  ingress {
    description      = "Allow Elastic"
    from_port        = 6788
    to_port          = 6788
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress { # Egress all allow
    description = "Egress allow"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_basic_web_8080"
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_security_group" "sg_basic_gluster" {
  name        = "sg_basic_gluster"
  description = "Allows GlusterFS ports"
  vpc_id = var.vpc_id

  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]
  }

  # GlusterFS ports https://docs.axway.com/bundle/SecureTransport_55_on_Azure_InstallationGuide_allOS_en_HTML5/page/Content/Azure/netSecurity/glusterFS--sg.htm
  ingress {
    description      = "Gluster port mapper"
    from_port        = 111
    to_port          = 111
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]
  }

  ingress {
    description      = "Gluster port mapper"
    from_port        = 111
    to_port          = 111
    protocol         = "udp"
    cidr_blocks      = [var.vpc_cidr_block]
  }

  ingress {
    description      = "Gluster Daemon"
    from_port        = 24007
    to_port          = 24011
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]
  }

  ingress {
    description      = "NFS ports"
    from_port        = 38465
    to_port          = 38469
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]
  }  

  ingress {
    description      = "Volume ports"
    from_port        = 49152
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]
  }

  egress { # Egress all allow
    description = "Egress allow"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_basic_gluster"
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}