provider "aws" {
  version     = "~> 1.39"
  region      = "${var.region}"
}

resource "aws_s3_bucket" "default" {
  bucket = "test-app-for-glovo-interview"
}

resource "aws_s3_bucket_object" "default" {
  bucket = "${aws_s3_bucket.default.id}"
  key    = "interview/app.zip"
  source = "app.zip"
}

# Service role
data "aws_iam_policy_document" "service" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["elasticbeanstalk.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "service" {
  name               = "java-app"
  assume_role_policy = "${data.aws_iam_policy_document.service.json}"
}

resource "aws_iam_role_policy_attachment" "enhanced-health" {
  role       = "${aws_iam_role.service.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_role_policy_attachment" "service" {
  role       = "${aws_iam_role.service.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}


resource "aws_elastic_beanstalk_application_version" "default" {
  name        = "interview"
  application = "java-app"
  description = "application version created by terraform"
  bucket      = "${aws_s3_bucket.default.id}"
  key         = "${aws_s3_bucket_object.default.id}"
}

# Beanstalk application
resource "aws_elastic_beanstalk_application" "interview" {
  name        = "java-app"
  description = "This is an application example"

  appversion_lifecycle {
    service_role          = "${aws_iam_role.service.arn}"
    max_count             = 128
    delete_source_from_s3 = true
  }
}

# Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "interview" {
  name                = "${var.application_name}-${var.application_environment}"
  application         = "${aws_elastic_beanstalk_application.interview.name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v3.0.4 running Tomcat 8 Java 8"
  tier                = "Worker"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  # Autoscaling configuration
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "2"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "2"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = "CPUUtilization"
  }

  # LB configuration
  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "SecurityGroups"
    value     = "default"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "classic"
  }

  setting {
    namespace = "aws:elb:listener:443"
    name      = "ListenerProtocol"
    value     = "HTTPS"
  }

  setting {
    namespace = "aws:elb:listener:443"
    name      = "InstancePort"
    value     = "8080"
  }

  setting {
    namespace = "aws:elb:listener:443"
    name      = "SSLCertificateId"
    value     = ""
  }

  # Internal behaviour
    setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "ManagedActionsEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "PreferredStartTime"
    value     = "${var.preferred_start_time}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name      = "UpdateLevel"
    value     = "${var.update_level}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name      = "InstanceRefreshEnabled"
    value     = "${var.instance_refresh_enabled}"
  }
}