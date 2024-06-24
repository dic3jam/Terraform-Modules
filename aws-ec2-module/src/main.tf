# encrypted volumes
# correct role
# bastion needs public IP
# swarm needs to be in private subnet

#the kms key for EBS encryption needs to be configured manually prior to deployment

resource "aws_key_pair" "basic-key" {
  public_key = var.SSHPUB
}

resource "aws_instance" "bastion" {
  ami           = var.ami
  instance_type = "t2.medium"

  root_block_device {
    encrypted = true
    kms_key_id = var.EBS-Key
  }

  key_name        = aws_key_pair.basic-key.key_name
  security_groups = var.bastion-security-groups
  subnet_id = var.public_subnets[0]
  iam_instance_profile = var.iam_profile
  associate_public_ip_address = true

  lifecycle {
    # for some reason prevent destroy does not work...
    prevent_destroy = false
    ignore_changes = all
    create_before_destroy = true
  }

  tags = {
    Name        = join("-", [var.Name,"Bastion"])
    Role = "Bastion"
    Environment = var.Environment-Tag
    Billing = var.Billing-Tag
  }
}

resource "aws_instance" "swarm-manager" {
  count = var.swarm_manager_count
  ami           = var.ami
  instance_type = var.instance_type

  root_block_device {
    encrypted = true
    kms_key_id = var.EBS-Key
    volume_size = var.volume_size
  }

  key_name        = aws_key_pair.basic-key.key_name
  security_groups = var.swarm-security-groups
  subnet_id = var.private_subnets[0]
  iam_instance_profile = var.iam_profile

  lifecycle {
    # for some reason prevent destroy does not work...
    prevent_destroy = false
    ignore_changes = all
    create_before_destroy = true
  }

  tags = {
    Name = join("-", [var.Name, "swarm-manager"])
    Role = "Swarm-Manager"
    Environment = var.Environment-Tag
    Billing = var.Billing-Tag
  }
}

resource "aws_instance" "swarm" {
  count         = var.swarm_worker_count
  ami           = var.ami
  instance_type = var.instance_type

  root_block_device {
    encrypted = true
    kms_key_id = var.EBS-Key
    volume_size = var.volume_size
  }

  key_name        = aws_key_pair.basic-key.key_name
  security_groups = var.swarm-security-groups
  subnet_id = var.private_subnets[0]
  iam_instance_profile = var.iam_profile

  lifecycle {
    # for some reason prevent destroy does not work...
    prevent_destroy = false
    ignore_changes = all
    create_before_destroy = true
  }

  tags = {
    Name = join("-", [var.Name, "swarm", count.index])
    Role = "Swarm"
    Environment = var.Environment-Tag
    Billing = var.Billing-Tag
  }
}
