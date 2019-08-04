# infra-code
Some Infra Code to create Frontend Server, NewsFeed Server, Quotes Server

## Assumptions
1. There is a hosted zone in AWS with name mayankkumar.com (Can be made Configurable. Add variable for it in variables.tf)

## Prerequisites
1. You should have AWS Account. :D

2. ~~Terraform should be installed.~~ Updated in code. Not to worry

3. A base AMI should be created in AWS on which Server specific AMI can be created. This can be bare or can contain  organization specific pre installation
   Information to create AMI: https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/AMIs.html

4. AWS Credentials should be configured on host in ~/.aws/credentials file.

5. ~~Packer Should be installed on host. (Or can be added in create_distribution.sh to install if not present)~~ Updated in code. Not to worry

## How to run
~~1. Clone/Download this repo on a host at suitable location. Command: git clone~~ https://github.com/mayankkumaryadav06/infra-code.git

~~2. Run scripts in following order:~~
   ~~- **create_distribution.sh**:  [This should be run only in case there is a change in code repository. https://github.com/ThoughtWorksInc/infra-problem ]~~
       ~~It will create Jar and Zip files for different servers to run and copy them in ansible folder which will be further used in packer to create server specific AMIs~~
   ~~- **create_baked_ami.sh**: This will create baked server specific AMIs. Run this when there is change in code repo and new jars and zip files are created.~~
    ~~This will create AMIs which will have a Version containing specific commit id i.e., the last commit in branch. This will help to know Codes are running against which commit.~~
   ~~- Create/Update Infrastructure. Commands to run.
     - **terraform init** : This will initialize terraform with relevant required modules or set up backend configurations~~
     ~~- **terraform plan [ -var "key=value" ] -out=plan/terraform_plan.out**:  This will create a plan of about what to~~ happen ~~when terraform is run. We are taking this plan output and if all is well then apply terraform against this plan. -var~~ is ~~an optional argument if you want to override any specific variable(s) default value.~~
     ~~-**terraform apply plan/terraform_plan.out** : This will run terraform to create Infrastructure as per plan~~

1. In Jenkins Server, point the path of JenkinsFile present in Git. This will eliminate need of running commands manually on hosts

## Future Work
1. Create CI pipeline to run these commands in automated format. **DONE**
   - Can be on demand pipeline or can be invovked using gitlab webhook on each commit in master/developer.
   **Done as on demand pipeline**

2. Create CD pipeline to create/update Infrastructure. **DONE**

3. Give options in Pipeline to override default variables value. **DONE**

4. Optimize code in AMI creation. Currently taking ~20min to create AMIs for all servers.

5. Move all download automated (in **create_distribution.sh**). All pre-requisites can be avoided to be done manually. **DONE**

6. Give option to make particular Server specific AMI

7. Do Blue Green Deployment to achieve lowest possible downtime while production deployment
