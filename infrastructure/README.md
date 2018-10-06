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
[here](https://github.com/fvalero86/interview/blob/master/infrastructure/main.tf#L10)
* Custom VPC for the app
* Elastic Beanstalk environment and application [app/main.tf]:(https://github.com/fvalero86/interview/blob/master/infrastructure/app/main.tf)
  * Autoscaling by CPU usage: [here](https://github.com/fvalero86/interview/blob/master/infrastructure/app/main.tf#L96)
* Cloudfront distribution [cloudfront/main.tf](https://github.com/fvalero86/interview/blob/master/infrastructure/cloudfront/main.tf):
  * Custom behaviour to redirect all the traffic (/) to the EBS LoadBalancer [here](https://github.com/fvalero86/interview/blob/master/infrastructure/cloudfront/main.tf#L31)
  * Custom header **X-Glovo-Systems-Engineer-Candidate** set to ` 1 ` [here](https://github.com/fvalero86/interview/blob/master/infrastructure/cloudfront/variables.tf#L70)
  
NOTE: In this specific case Ansible or whatever kind of CM is not neccesary due we manage all our app versions with EBS using the Rolling update [here](https://github.com/fvalero86/interview/blob/master/infrastructure/app/main.tf#L133)

NOTE: Log stuff, related with log retention, rotation, prefix, etc.. where intentionally omited for brevity.