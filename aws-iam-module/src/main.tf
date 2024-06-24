# Policies

resource "aws_iam_policy" "Elk-AWSIntegration" {
  name = "Elk-AWSIntegration"
  path = "/"
  description = "Policy for Elastic AWS integration identity"

  policy = file("./elk-awsintegration.json") 
}

resource "aws_iam_policy" "basic-SSM-Access" {
  name = "basic-SSM-Access"
  path = "/"
  description = "Policy for users to access EC2 resources with SSM"

  policy = file("./ssm-access.json") 
}

resource "aws_iam_policy" "basic-SSM-Managed-InstanceCore+Encryption" {
  name = "basic-SSM-Managed-InstanceCore+Encryption"
  path = "/"
  description = "Policy for a private EC2 instance to be accessed through SSM with a KMS encrypted session"

  policy = file("./ssmmanagedinstancecoreencryption.json") 
}

# Roles

resource "aws_iam_role" "basic_EC2" {
  name = "basic_EC2"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_policy_attachment" "basic_EC2-attach" {
  name       = "basic_EC2-attach"
  roles      = [aws_iam_role.basic_EC2]
  policy_arn = aws_iam_policy.basic-SSM-Managed-InstanceCore+Encryption.arn
}

# User Groups

resource "aws_iam_group" "basicAdministrators" {
  name = "basicAdministrators"
}

resource "aws_iam_policy_attachment" "basicAdministrators-attach" {
  name       = "basicAdministrators-attach"
  groups     = [aws_iam_group.basicAdministrators]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group" "basicSOC" {
  name = "basicSOC"
}

resource "aws_iam_policy_attachment" "basicSOC-attach-1" {
  name       = "basicSOC-attach-1"
  groups     = [aws_iam_group.group.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSAuditManagerAdministratorAccess"
}

resource "aws_iam_policy_attachment" "basicSOC-attach-2" {
  name       = "basicSOC-attach-2"
  groups     = [aws_iam_group.group.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSSecurityHubFullAccess"
}

resource "aws_iam_policy_attachment" "basicSOC-attach-3" {
  name       = "basicSOC-attach-3"
  groups     = [aws_iam_group.group.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSWAFConsoleFullAccess"
}

resource "aws_iam_policy_attachment" "basicSOC-attach-4" {
  name       = "basicSOC-attach-4"
  groups     = [aws_iam_group.group.name]
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

resource "aws_iam_group" "basic_ViewOnlySSM" {
  name = "basic_ViewOnlySSM"
}

resource "aws_iam_policy_attachment" "basic_ViewOnlySSM-attach-1" {
  name       = "basic_ViewOnlySSM-attach-1"
  groups     = [aws_iam_group.group.name]
  policy_arn = aws_iam_policy.basic-SSM-Access.arn
}

resource "aws_iam_policy_attachment" "basic_ViewOnlySSM-attach-2" {
  name       = "basic_ViewOnlySSM-attach-2"
  groups     = [aws_iam_group.group.name]
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}