#!/bin/bash -xe
# Check for errors. Piping to tee might hide the exit code of the script
set -o pipefail
# Check SSH connection
ssh -o "StrictHostKeyChecking=no" -T git@github.com || true

export M2_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}
export CURRENT_DIR="$(realpath .)"
export TEST_ID="${BUILD_NUMBER:-TEST}-$(date +%Y-%m-%d_%H-%M-%S)"
export RESULTS_DIR="$(realpath "results-${TEST_ID}")"

function clone_and_build() {
    for repository in "$@"; do
        echo "Getting files from $repository repository..."
        if [[ ! $repository =~ ^git@github\.com:.*\.git$ ]]; then
            echo "Invalid repository!"
            return 1
        fi
        repo_dir=$(basename "$repository" .git)
        if [[ ! -d $repo_dir ]]; then
            git clone --depth 1 "${repository}"
        else
            pushd $repo_dir
            git status
            git pull
            git status
            popd
        fi
        echo "Running Maven Build on $repo_dir"
        mvn clean install -V -B -f $repo_dir
    done
}

function exit_handler() {
    rv=$?
    if [[ -f ${CURRENT_DIR}/performance_test_run.log ]] && [[ -d $RESULTS_DIR ]]; then
        mv ${CURRENT_DIR}/performance_test_run.log $RESULTS_DIR
    fi
    ARCHIVE_DIR="${CURRENT_DIR}/archive"
    if [[ $rv -eq 0 ]]; then
        echo "Build is successful."
        mkdir -p ${ARCHIVE_DIR}/successful
        if [[ -d $RESULTS_DIR ]]; then
            if [[ ! -z $PRODUCT_REPO ]]; then
                if [[ $PRODUCT_REPO =~ ^git@github\.com:.*\.git$ ]]; then
                    # Commit results:
                    # Must clone with SSH
                    git clone -b ${REPO_BRANCH:-master} --depth 1 $PRODUCT_REPO
                    repo_dir=$(basename "$PRODUCT_REPO" .git)
                    pushd $repo_dir
                    git checkout -b performance-test-${TEST_ID}
                    mkdir -p performance/benchmarks
                    cp $RESULTS_DIR/summary.{csv,md} performance/benchmarks
                    git add performance/benchmarks/summary.{csv,md}
                    git commit -m "Update performance test results"
                    git push -u origin performance-test-${TEST_ID}
                    popd
                else
                    echo "WARNING: The 'PRODUCT_REPO' environment variable not a valid SSH URL."
                fi
            else
                echo "WARNING: The 'PRODUCT_REPO' environment variable is not set."
            fi
            mv -v $RESULTS_DIR ${ARCHIVE_DIR}/successful
        fi
    else
        echo "Build failed!"
        mkdir -p ${ARCHIVE_DIR}/failed
        if [[ -d $RESULTS_DIR ]]; then
            mv -v $RESULTS_DIR ${ARCHIVE_DIR}/failed
        fi
    fi
    exit $rv
}

trap exit_handler EXIT

export PRODUCT_REPO="git@github.com:ballerina-platform/ballerina-lang.git"

declare -a repositories
repositories+=("git@github.com:ldclakmal/performance-common.git")
repositories+=("git@github.com:ldclakmal/ballerina-performance.git")

clone_and_build "${repositories[@]}"

echo "Extracting scripts..."
cd ballerina-performance/distribution/target
tar -xf *.tar.gz

./cloudformation/run-performance-tests.sh -u ${BUILD_USER_EMAIL} -f *.tar.gz \
    -d ${RESULTS_DIR} \
    -k /ballerina_aws.pem -n 'ballerina_aws' \
    -j /build/jenkins-home/workspace/ballerina-platform/resources/apache-jmeter-4.0.tgz \
    -o /build/software/jdk-8u192-linux-x64.tar.gz \
    -g /build/jenkins-home/workspace/ballerina-platform/resources/gcviewer-1.36-SNAPSHOT.jar \
    -s 'ballerina-perf-test-' \
    -b ballerina-performance -r 'us-east-1' \
    -J "${JMETER_CLIENT_EC2_INSTANCE_TYPE}" \
    -S "${JMETER_SERVER_EC2_INSTANCE_TYPE}" \
    -N "${BACKEND_EC2_INSTANCE_TYPE}" \
    -i "/build/jenkins-home/workspace/ballerina-platform/resources/${BALLERINA_DEB}" \
    -B ${BALLERINA_EC2_INSTANCE_TYPE} \
    -t ${NUMBER_OF_STACKS} \
    -p ${PARALLEL_PARAMETER_OPTION} \
    -- ${RUN_PERF_OPTS} | tee ${CURRENT_DIR}/performance_test_run.log
