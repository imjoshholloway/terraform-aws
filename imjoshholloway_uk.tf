resource "aws_route53_zone" "imjoshholloway_uk" {
  name = "imjoshholloway.uk."
}

resource "aws_route53_record" "imjoshholloway_uk_apex" {
  zone_id = aws_route53_zone.imjoshholloway_uk.zone_id
  name    = "imjoshholloway.uk"
  type    = "A"
  ttl     = "60"
  records = ["185.199.108.153", "185.199.109.153", "185.199.110.153", "185.199.111.153"]
}

resource "aws_route53_record" "imjoshholloway_uk_mx" {
  zone_id = aws_route53_zone.imjoshholloway_uk.zone_id
  name    = "imjoshholloway.uk"
  type    = "MX"
  ttl     = "60"
  records = [
    "10 ASPMX.L.GOOGLE.COM.",
    "20 ALT1.ASPMX.L.GOOGLE.COM.",
    "30 ALT2.ASPMX.L.GOOGLE.COM.",
    "30 ASPMX2.GOOGLEMAIL.COM.",
    "30 ASPMX3.GOOGLEMAIL.COM.",
  ]
}

