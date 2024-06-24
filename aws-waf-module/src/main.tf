resource "aws_wafv2_web_acl" "basic-ACL" {
  name  = join(var.Name, ["-ACL"])
  scope = "REGIONAL"

  default_action {
    allow {
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "WAF_Common_Protections"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 3
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesLinuxRuleSet"
    priority = 5
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesLinuxRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 1
    override_action {
      none {
      }
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 2
    override_action {
      none {
      }
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAnonymousIpList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 4
    override_action {
      none {
      }
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesUnixRuleSet"
    priority = 7
    override_action {
      none {
      }
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesUnixRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesUnixRuleSet"
      sampled_requests_enabled   = true
    }
  }

  tags = {
    Name = join(var.Name, ["-ACL"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }

}

resource "aws_cloudwatch_log_group" "basic-ACL-Loggroup" {
  name              = "aws-waf-logs-wafv2-web-acl"
  retention_in_days = 30
  tags = {
    Name = join(var.Name, ["-ACL-Loggroup"])
    Billing = var.Billing-Tag
    Environment = var.Environment-Tag
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "basic-ACL-Logging" {
  log_destination_configs = [aws_cloudwatch_log_group.basic-ACL-Loggroup.arn]
  resource_arn            = aws_wafv2_web_acl.basic-ACL.arn
  depends_on = [
    aws_wafv2_web_acl.basic-ACL,
    aws_cloudwatch_log_group.basic-ACL-Loggroup
  ]
}

resource "aws_wafv2_web_acl_association" "basic-ACL-Association" {
  resource_arn = var.ALB-ARN
  web_acl_arn  = aws_wafv2_web_acl.basic-ACL.arn
  depends_on = [
    aws_wafv2_web_acl.basic-ACL,
    aws_cloudwatch_log_group.basic-ACL-Loggroup
  ]
}