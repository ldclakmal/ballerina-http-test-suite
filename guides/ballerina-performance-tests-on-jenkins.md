# How to execute Ballerina performance tests on Jenkins

### Prerequisites

The following steps are only one time configurations. Once all the prerequisites are completed, you can start with the next section.

#### AWS
1. Create IAM User in AWS account `wso2-rnd-ipaas` with proper permissions.
2. Create S3 bucket in `us-east-1` with the name `ballerina-performance-artifacts`.
3. Generate an EC2 key pair with the name `ballerina_aws` and the format of `pem` and download.

#### VM
1. `ballerina-performance.key` file which is the SSH key file for the Jenkins VM `192.168.114.17`.
2. VPN access for connecting to WSO2 Jenkins machine.
3. Download and SCP following files:
    1. **jdk-8u212-linux-x64.tar.gz** at https://www.oracle.com/java/technologies/javase/javase8u211-later-archive-downloads.html
        ```shell
        $ scp -i ~/.ssh/ballerina-performance.key jdk-8u212-linux-x64.tar.gz ubuntu@192.168.114.17:/build/software/
        ```
    3. **apache-jmeter-5.1.1.tgz** at https://archive.apache.org/dist/jmeter/binaries/
        ```shell
        $ scp -i ~/.ssh/ballerina-performance.key apache-jmeter-5.1.1.tgz ubuntu@192.168.114.17:/build/jenkins-home/workspace/ballerina-platform/resources
        ```
    4. **ballerina_aws.pem** which is created earlier:
        ```shell
        $ scp -i ~/.ssh/ballerina-performance.key ballerina_aws.pem ubuntu@192.168.114.17:/home/ubuntu/
        $ scp -i ~/.ssh/ballerina-performance.key ballerina_aws.pem ubuntu@192.168.114.17:/
        ```
4. Configure AWS credentials (Access key ID & secret access key) in Jenkins VM.
    ```shell
    $ ssh -i ~/.ssh/ballerina-performance.key ubuntu@192.168.114.17
    $ cd ~/.aws/
    $ vim credentials
    ```

### Let's Start

1. Download the required Ballerina Linux installer for the test.
    ```shell
    $ ssh -i ~/.ssh/ballerina-performance.key ubuntu@192.168.114.17
    $ cd /build/jenkins-home/workspace/ballerina-platform/resources
    $ curl -O https://dist.ballerina.io/downloads/<version>/ballerina-linux-installer-x64-<version>.deb
    ```
2. Go to https://wso2.org/jenkins/ and login with WSO2 credentials.
3. Go to https://wso2.org/jenkins/job/ballerina-platform/job/ballerina-performance-execution/ to start the Ballerina performance tests.
4. Click on "Build with Parameters" on the left side navigation menu and fill the parameters as required.
5. Click on the "Build" button to start the test job.

---

#### NOTES

##### Nodes in public subnet
- We can connect to bastion, jmeter-client nodes from the jenkins node.
- `$ ssh -i ~/ballerina_aws.pem ubuntu@<instance-public-ip>`

##### Nodes in private subnet
- We can connect to backend, ballerina, jmeter-server-1, jmeter-server-2 nodes from the bastion node.
- `$ ssh -i ~/private_key.pem ubuntu@<instance-private-ip>`

---

### Resources

- https://github.com/wso2/performance-common
- https://github.com/ballerina-platform/ballerina-performance
