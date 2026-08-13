data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "web" {
  name_prefix   = "ha-web-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  # user_data...
 user_data = base64encode(<<-EOF
#!/bin/bash

dnf update -y
dnf install -y nginx wget unzip

systemctl enable nginx
systemctl start nginx

rm -rf /usr/share/nginx/html/*

cd /tmp

wget -O template.zip "https://www.tooplate.com/download/2167_orbital"

mkdir -p template
unzip -o template.zip -d template

WEBSITE_DIR=$(dirname "$(find /tmp/template -name index.html -type f | head -1)")

cp -r "$WEBSITE_DIR"/* /usr/share/nginx/html/

chown -R nginx:nginx /usr/share/nginx/html
chmod -R 755 /usr/share/nginx/html

systemctl restart nginx

EOF
)

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ha-web-server"
    }
  }
}