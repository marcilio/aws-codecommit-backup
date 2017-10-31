#!/bin/bash

# Copyright 2012-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# 
# Licensed under the Amazon Software License (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
# 
# http://aws.amazon.com/asl/
# 
# or in the "license" file accompanying this file. This file is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied. See the License for the specific language governing
# permissions and limitations under the License.

#----- Change these parameters to suit your environment -----#
aws_profile="default"
backup_schedule="cron(0 2 * * ? *)"
scripts_s3_bucket="codecommit-backups" # bucket must exist in the SAME region the deployment is taking place
backups_s3_bucket="codecommit-backups" # bucket must exist and have no policy that disallows PutObject from CodeBuild
stack_name="codecommit-backups"
#----- End of user parameters  -----#

# You can also change these parameters but it's not required
cfn_template="codecommit_backup_cfn_template.yaml"
cfn_parameters="codecommit_backup_cfn_parameters.json"
zipfile="codecommit_backup_scripts.zip"

zip -r "${zipfile}" ./
aws s3 --profile $aws_profile cp "${zipfile}" "s3://${scripts_s3_bucket}"
rm -f "${zipfile}"

aws cloudformation create-stack \
    --profile $aws_profile \
    --stack-name "${stack_name}" \
    --template-body "file://./${cfn_template}" \
    --parameters \
        ParameterKey="CodeCommitBackupsScriptsS3Bucket",ParameterValue="${scripts_s3_bucket}" \
        ParameterKey="CodeCommitBackupsS3Bucket",ParameterValue="${backups_s3_bucket}" \
        ParameterKey="BackupSchedule",ParameterValue="${backup_schedule}" \
        ParameterKey="BackupScriptsFile",ParameterValue="${zipfile}" \
    --capabilities CAPABILITY_IAM

