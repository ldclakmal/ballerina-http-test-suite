#!/bin/bash -xe
. ../common.sh

declare -a repositories
repositories+=("git@github.com:chrishantha/performance-common.git")
repositories+=("git@github.com:VirajSalaka/performance-apim.git")

clone_and_build "${repositories[@]}"
wget -N https://www.dropbox.com/s/w4jr8xxab3dux4u/wso2am-micro-gw-toolkit-3.0.2-SNAPSHOT.zip?dl=0 -O wso2am-micro-gw-toolkit-3.0.2-SNAPSHOT.zip

echo "Extracting scripts..."
cd performance-apim/distribution/target
tar -xf *.tar.gz

cp -v ../../../wso2am-2.6.0.zip wso2am.zip
cp -v ../../../wso2am-micro-gw-toolkit-3.0.2-SNAPSHOT.zip wso2am-micro-gw.zip

./cloudformation/run-micro-gw-performance-tests.sh -u ${BUILD_USER_EMAIL} -f *.tar.gz \
    -d ${RESULTS_DIR} \
    -k ~/keys/apim-perf-test.pem -n 'apim-perf-test' \
    -j ~/apache-jmeter-5.1.1.tgz -o ~/jdk-8u212-linux-x64.tar.gz \
    -g ~/gcviewer-1.36-SNAPSHOT.jar -s 'wso2-api-mgw-test-' \
    -b apimgwperformancetest -r 'us-east-1' \
    -J "${JMETER_CLIENT_EC2_INSTANCE_TYPE}" \
    -S "${JMETER_SERVER_EC2_INSTANCE_TYPE}" \
    -N "${BACKEND_EC2_INSTANCE_TYPE}" \
    -a ${PWD}/wso2am.zip \
    -m ${PWD}/wso2am-micro-gw.zip \
    -c ~/mysql-connector-java-8.0.13.jar \
    -A ${WSO2_API_MANAGER_EC2_INSTANCE_TYPE} \
    -D ${WSO2_API_MANAGER_EC2_RDS_DB_INSTANCE_CLASS} \
    -t ${NUMBER_OF_STACKS} \
    -p ${PARALLEL_PARAMETER_OPTION} \
    -- ${RUN_PERF_OPTS} | tee ${CURRENT_DIR}/performance_test_run.log
