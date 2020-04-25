# ADD all Microsoft IPs to mail server security group for office365 whitelisting

Microsoft did not have a good way of consuming all of their frequently changing Office365 server Ip addresses as they are only published on their website.
This script parses the ip addresses out of the website and adds them to a security group to allow mail from any o365 microsoft server to be available

## Requirements

Will need the policy added to the role attached  to your mail server instance so that the script can manipulate security group directives.

## Instance Policy
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:DeleteSecurityGroup",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:RevokeSecurityGroupIngress"
            ],
            "Resource": "arn:aws:ec2:*:*:security-group/security_group_id"
        }
    ]
}

```


## Usage
Can run this as a cronjob to pull the microsoft ips every day as they will change sometimes.

```
./script security_group_id_port_587 security_group_id_port_25
```
