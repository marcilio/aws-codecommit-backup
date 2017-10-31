
# Instructions

* Make sure the AWS Command-line Interface is installed
* Update deploy.sh with the AWS profile and S3 buckets you with to use
* You'll also have to update the CloudFormation template parameters (codecommit_backup_cfn_parameters.json) to indicate the S3 buckets you wish to use 
* The AWS profile must have permissions to create IAM roles, CodeBuild project and Lambda functions at a minimum
* All CodeCommit repositories within the AWS region where the solution was deployed to will be backed up everyday at 2am (cron(0 2 * * ? *)) into the S3 bucket specified
* If you wish to change the backup frequency, update the "cron" expression in the CloudFormation template (codecommit_backup_cfn_template.yaml). Right now it's set to 
* Run script ./deploy.sh to deploy the solution
