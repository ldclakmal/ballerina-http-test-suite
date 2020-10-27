# How to execute Ballerina performance tests on Jenkins

## Prerequisites

We have to make sure the following installers are in place in order to run the tests. Most importantly we need to SCP the Ballerina deb installer we are going to execute.

* Download `jdk-8u212-linux-x64.tar.gz` and SCP into jenkins machine.

```shell
$ scp -i ~/.ssh/ballerina-performance.key jdk-8u212-linux-x64.tar.gz ubuntu@192.168.114.17:/build/software/
```

* Download `apache-jmeter-5.1.1.tgz` and SCP into jenkins machine.
```shell
$ scp -i ~/.ssh/ballerina-performance.key apache-jmeter-5.1.1.tgz ubuntu@192.168.114.17:/build/jenkins-home/workspace/ballerina-platform/resources
```

* SCP `ballerina.deb` into jenkins machine.
```shell
$ scp -i ~/.ssh/ballerina-performance.key /home/chanakal/Downloads/ballerina.deb ubuntu@192.168.114.17:/build/jenkins-home/workspace/ballerina-platform/resources
```

## Let's Start

1. Go to https://wso2.org/jenkins/ and login with WSO2 credentials.
2. Go to https://wso2.org/jenkins/job/ballerina-platform/job/ballerina-performance-execution/ to start the Ballerina performance tests.
3. Click on "Build with Parameters" on the left side navigation menu.
4. Now we have to enter the required parameters for the particular test job. All the parameters have a description.
5. Once done, click on the "Build" button to start the test job.

---

### NOTES

##### jenkins node:
`$ ssh -i ~/.ssh/ballerina-performance.key ubuntu@192.168.114.17`

`$ cd /build/jenkins-home/workspace/ballerina-platform/`

##### nodes in public subnet:

We can connect to bastion, jmeter-client nodes from the jenkins node.

`$ ssh -i ~/ballerina_aws.pem ubuntu@<instance-public-ip>`

##### nodes in private subnet:

We can connect to backend, ballerina, jmeter-server-1, jmeter-server-2 nodes from the bastion node.

`$ ssh -i ~/private_key.pem ubuntu@<instance-private-ip>`
