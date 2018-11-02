VPC tutorial etc
https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Tutorials.WebServerDB.CreateVPC.html

Change the Connection Method to Standard TCP/IP.
DBNAME		DEMODB
USERNAME	user1
PASSWORD	Password1
PORT		1521

It takes AWS about 15 minutes to create the RDS db.

The terraform commands to run the scripts are:

	terraform init -var-file="<location and name of your secrets file>.auto.tfvars"
	terraform apply -var-file="<location and name of your secrets file>.auto.tfvars"
	terraform delete -var-file="<location and name of your secrets file>.auto.tfvars"

where <location and name of your secrets file>.auto.tfvars is similar to the following:

	#MySecretKeys.auto.tfvars
	access_key = "<your AWS access key"
	secret_key = "<your AWS secret key>"