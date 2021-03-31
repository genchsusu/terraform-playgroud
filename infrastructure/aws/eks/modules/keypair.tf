resource "aws_key_pair" "eks" {
  key_name   = var.cluster_name
  public_key = var.public_key
}