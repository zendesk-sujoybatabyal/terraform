resource "aws_instance" "web" {
    ami = "ami-0f58b397bc5c1f2e8"
    instance_type = "t2.micro"
    count = 2
    vpc_security_group_ids = ["sg-083c3af9d6d752a91","sg-0748659397f60e673"]
}
