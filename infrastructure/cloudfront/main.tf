# Create cloudfront distribution to include the header X-Glovo-Systems-Engineer-Candidate
# pointing to the application load balancer 
resource "aws_cloudfront_distribution" "interview" {
  enabled             = "${var.enabled}"
  is_ipv6_enabled     = "${var.is_ipv6_enabled}"
  comment             = "${var.comment}"
  default_root_object = "${var.default_root_object}"
  price_class         = "${var.price_class}"

  origin {
    domain_name = "${var.load_balancer_id}"
    origin_id   = "${var.load_balancer.id}"
    origin_path = "${var.origin_path}"
  }

  viewer_certificate {
    acm_certificate_arn            = "${var.acm_certificate_arn}"
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "${var.minimum_protocol_version}"
    cloudfront_default_certificate = "${var.acm_certificate_arn == "" ? true : false}"
  }

  default_cache_behavior {
    allowed_methods  = "${var.allowed_methods}"
    cached_methods   = "${var.cached_methods}"
    target_origin_id = "${var.load_balancer_id}"
    compress         = "${var.compress}"

    forwarded_values {
      query_string = "${var.forward_query_string}"
      headers      = ["${var.forward_header_values}"]

      cookies {
        forward = "${var.forward_cookies}"
      }
    }

    viewer_protocol_policy = "${var.viewer_protocol_policy}"
    default_ttl            = "${var.default_ttl}"
    min_ttl                = "${var.min_ttl}"
    max_ttl                = "${var.max_ttl}"
  }

  tags = "${module.distribution_label.tags}"
}