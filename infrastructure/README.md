# Infrastructure
This template is made with Terraform and it's divided in two main parts:
* app
* cloudfront

both `main.tf` has all the logic.

The variable files are distributed per environment:
* stg (loaded by default)
* pre
* prod

## Components
* S3 bucket with the application code **systems-engineer-interview-1.0-SNAPSHOT.jar** (zipped):
[here](app/main.tf#L10)
* Custom VPC for the app
* Elastic Beanstalk environment and application in [app/main.tf](app/main.tf):
  * Autoscaling by CPU usage: [here](app/main.tf#L96)
  * Update policy: [here](app/main.tf#L133)
  * Deployment policy: [here](app/main.tf#L133)
  * Asg and other parameteres related with the app could be found in the `settings` blocks.
* Cloudfront distribution in [cloudfront/main.tf](cloudfront/main.tf):
  * Custom behaviour to redirect all the traffic (/) to the EBS LoadBalancer [here](cloudfront/main.tf#L31)
  * Custom header **X-Glovo-Systems-Engineer-Candidate** set to ` 1 ` [here](cloudfront/variables.tf#L70)

## Notes
1. In this specific case Ansible or whatever kind of CM is not neccesary due we manage all our app versions with EBS using the Rolling update [here](app/main.tf#L133)

2. The main idea is build all the instances stateless and forward logs, metrics, etc into cloudwatch or another log concentrator like an ELK infrastructure.

3. Log stuff, related with log retention, rotation, prefix, etc.. where intentionally omited for brevity.