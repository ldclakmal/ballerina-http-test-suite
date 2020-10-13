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

**Working Directory:** `$ /build/jenkins-home/workspace/ballerina-platform/`

**Jenkins Node:** `$ ssh -i ~/.ssh/ballerina-performance.key ubuntu@192.168.114.17`

**Bastion Node:** `$ ssh -i ballerina_aws.pem ubuntu@35.172.33.196`

**Ballerina Node:** `$ ssh -i private_key.pem ubuntu@10.0.1.244`
