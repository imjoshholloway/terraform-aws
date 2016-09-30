resource "aws_route53_zone" "imjoshholloway_co_uk" {
   name = "imjoshholloway.co.uk."
}

resource "aws_s3_bucket" "imjoshholloway_co_uk" {
   bucket = "imjoshholloway.co.uk"
   acl    = "private"

   website {
      redirect_all_requests_to = "http://imjoshholloway.uk"
   }
}

resource "aws_route53_record" "imjoshholloway_co_uk_apex" {
   zone_id  = "${aws_route53_zone.imjoshholloway_co_uk.zone_id}"
   name     = "imjoshholloway.co.uk"
   type     = "A"

   alias {
      name                      = "${aws_s3_bucket.imjoshholloway_co_uk.website_domain}"
      zone_id                   = "${aws_s3_bucket.imjoshholloway_co_uk.hosted_zone_id}"
      evaluate_target_health    = false
   }
}
