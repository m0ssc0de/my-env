provider "alicloud" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

# Create a new ECS instance for a VPC
resource "alicloud_security_group" "group" {
  name        = "tf_test_foo"
  description = "foo"
  vpc_id      = "${alicloud_vpc.vpc.id}"
}

resource "alicloud_security_group_rule" "allow_all_tcp" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = "${alicloud_security_group.group.id}"
  cidr_ip           = "0.0.0.0/0"
}


resource "alicloud_instance" "instance" {
  # cn-beijing
  availability_zone = "${var.zone}"
  security_groups   = "${alicloud_security_group.group.*.id}"

  password = "Len0v0213"

  # series III
  instance_charge_type       = "PostPaid"
  spot_strategy              = "SpotAsPriceGo"
  auto_release_time          = "${timeadd(timestamp(), "1h")}"
  internet_charge_type       = "PayByBandwidth"
  instance_type              = "ecs.n1.tiny"
  system_disk_category       = "cloud_efficiency"
  image_id                   = "ubuntu_18_04_64_20G_alibase_20190624.vhd"
  instance_name              = "test_foo"
  vswitch_id                 = "${alicloud_vswitch.vswitch.id}"
  internet_max_bandwidth_out = 10
}

# Create a new ECS instance for VPC
resource "alicloud_vpc" "vpc" {
  cidr_block = "172.16.0.0/12"
}

resource "alicloud_vswitch" "vswitch" {
  vpc_id = "${alicloud_vpc.vpc.id}"
  # Other parameters...
  cidr_block        = "172.16.0.0/21"
  availability_zone = "${var.zone}"
}
