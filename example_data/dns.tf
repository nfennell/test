terraform {
  required_providers {
    ns1 = {
      source                = "ns1-terraform/ns1"
      configuration_aliases = [ns1]
    }
  }
}

# Primary Zone
resource "ns1_zone" "primary-zone-1" {
  zone                   = "${var.keyword}.training"
  ttl                    = 300
  autogenerate_ns_record = true
  networks               = [0]
}


resource "ns1_zone" "secondary-zone-1" {
  zone    = "secondary.${ns1_zone.primary-zone-1.zone}"
  primary = "159.89.126.218"
  #additional_primaries = ["3.3.3.3", "4.4.4.4"]
  networks = [0]
}


# A Record - Single IP
resource "ns1_record" "a-1" {
  zone   = ns1_zone.primary-zone-1.zone
  domain = "sip.${ns1_zone.primary-zone-1.zone}"
  type   = "A"
  ttl    = 300

  answers {
    answer = "9.9.9.9"
  }

}

# A Record - Single IP
resource "ns1_record" "a-2" {
  zone   = ns1_zone.primary-zone-1.zone
  domain = "test.${ns1_zone.primary-zone-1.zone}"
  type   = "A"
  ttl    = 300

  answers {
    answer = "142.5.5.1"
  }

}

# AAAA Record - Single IP
resource "ns1_record" "aaaa-1" {
  zone   = ns1_zone.primary-zone-1.zone
  domain = "sip.${ns1_zone.primary-zone-1.zone}"
  type   = "AAAA"
  ttl    = 300

  answers {
    answer = "2001:db8:3333:4444:5555:6666:7777:8888"
  }

}


# CNAME record resource "ns1_record" "cname-1" {
resource "ns1_record" "cname-1" {
  zone   = ns1_zone.primary-zone-1.zone
  domain = "tube.${ns1_zone.primary-zone-1.zone}"
  type   = "CNAME"
  answers {
    answer = "video.${ns1_zone.primary-zone-1.zone}"
  }
}

# TXT record resource "ns1_record" "txt-1" {
resource "ns1_record" "alias-1" {
  zone   = ns1_zone.primary-zone-1.zone
  domain = ns1_zone.primary-zone-1.zone
  type   = "ALIAS"
  answers {
    answer = ns1_record.a-1.domain
  }
}

# SRV record resource "ns1_record" "srv-1" {
resource "ns1_record" "srv-1" {
  zone   = ns1_zone.primary-zone-1.zone
  domain = "pbx.${ns1_zone.primary-zone-1.zone}"
  type   = "SRV"
  answers {
    answer = "10 0 5060 sip.${ns1_zone.primary-zone-1.zone}"
  }
}


# A Record - Multi Group/Answer
resource "ns1_record" "a-metadata" {
  zone   = ns1_zone.primary-zone-1.zone
  domain = "video.${ns1_zone.primary-zone-1.zone}"
  type   = "A"
  ttl    = 300


  regions {
    name = "europe"
    meta = {
      georegion = "EUROPE"
    }
  }

  regions {
    name = "us-east"
    meta = {
      georegion = "US-EAST"
    }
  }


  answers {
    answer = "2.0.0.2"
    region = "us-east"
    meta = {
      cost = 90
      up : true
    }
  }

  answers {
    answer = "2.0.0.4"
    region = "us-east"
    meta = {
      cost = 80
      up : true
    }
  }

  answers {
    answer = "4.0.0.6"
    region = "us-east"
    meta = {
      cost = 70
      up : false
    }
  }

  answers {
    answer = "4.0.0.8"
    region = "us-east"
    meta = {
      cost = 60
      up : true
    }
  }

  answers {
    answer = "3.0.0.1"
    region = "europe"
    meta = {
      cost = 90
      up : true
    }
  }
  answers {
    answer = "3.0.0.3"
    region = "europe"
    meta = {
      cost = 80
      up : true
    }
  }
  answers {
    answer = "5.0.0.5"
    region = "europe"
    meta = {
      cost = 70
      up : false
    }
  }
  answers {
    answer = "5.0.0.7"
    region = "europe"
    meta = {
      cost = 60
      up : true
    }
  }


}
