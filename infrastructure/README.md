# Infrastructure
This template is made with Terraform and is an unique file with all the infra.
The variable files are distributed per environment:
* stg (by default)
* pre
* prod

`main.tf` has all the logic.

## Components
* S3 bucket with the application code **systems-engineer-interview-1.0-SNAPSHOT.jar** (zipped):
[here](https://github.com/fvalero86/interview/blob/master/infrastructure/main.tf#L10)
* Custom VPC for the app
* Elastic Beanstalk environment and application:
  * Autoscaling by CPU usage: **here**
* Cloudfront distribution:
  * Custom behaviour to redirect all the traffic (/) to the EBS LoadBalancer 
  * Custom header **X-Glovo-Systems-Engineer-Candidate** set to ` 1 `
  
NOTE: In this specific case Ansible or whatever kind of CM is not neccesary due we manage all our app versions with EBS using the Rolling update **here**

NOTE: Log stuff, related with log retention, rotation, prefix, etc.. where intentionally omited for brevity.