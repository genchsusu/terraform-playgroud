## Create EKS cluster with terraform

Please create `.auto.tfvars` and modify `makefile`

If you want to store you `terraform.tfstate` in S3, please turn it on in `main.tf`

Then run

```
make init
make plan
make install
```