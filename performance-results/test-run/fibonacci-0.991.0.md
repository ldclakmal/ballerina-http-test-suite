# Ballerina Performance Test Results

During each release, we execute various automated performance test scenarios and publish the results.

| Test Scenarios | Description |
| --- | --- |
| 10th Fibonacci Number | An HTTP Service, which calculate the 10th fibonacci number. |
| 20th Fibonacci Number | An HTTP Service, which calculate the 20th fibonacci number. |
| 30th Fibonacci Number | An HTTP Service, which calculate the 30th fibonacci number. |

Our test client is [Apache JMeter](https://jmeter.apache.org/index.html). We test each scenario for a fixed duration of
time. We split the test results into warmup and measurement parts and use the measurement part to compute the
performance metrics.

A majority of test scenarios use a [Netty](https://netty.io/) based back-end service which echoes back any request
posted to it after a specified period of time.

We run the performance tests under different numbers of concurrent users, message sizes (payloads) and back-end service
delays.

The main performance metrics:

1. **Throughput**: The number of requests that the Ballerina service processes during a specific time interval (e.g. per second).
2. **Response Time**: The end-to-end latency for an operation of invoking a Ballerina service. The complete distribution of response times was recorded.

In addition to the above metrics, we measure the load average and several memory-related metrics.

The following are the test parameters.

| Test Parameter | Description | Values |
| --- | --- | --- |
| Scenario Name | The name of the test scenario. | Refer to the above table. |
| Heap Size | The amount of memory allocated to the application | 2G |
| Concurrent Users | The number of users accessing the application at the same time. | 100, 300, 1000 |
| Message Size (Bytes) | The request payload size in Bytes. | 50 |
| Back-end Delay (ms) | The delay added by the back-end service. | 0 |

The duration of each test is **900 seconds**. The warm-up period is **300 seconds**.
The measurement results are collected after the warm-up period.

A [**c5.xlarge** Amazon EC2 instance](https://aws.amazon.com/ec2/instance-types/) was used to install Ballerina.

The following are the measurements collected from each performance test conducted for a given combination of
test parameters.

| Measurement | Description |
| --- | --- |
| Error % | Percentage of requests with errors |
| Average Response Time (ms) | The average response time of a set of results |
| Standard Deviation of Response Time (ms) | The “Standard Deviation” of the response time. |
| 99th Percentile of Response Time (ms) | 99% of the requests took no more than this time. The remaining samples took at least as long as this |
| Throughput (Requests/sec) | The throughput measured in requests per second. |
| Average Memory Footprint After Full GC (M) | The average memory consumed by the application after a full garbage collection event. |

The following is the summary of performance test results collected for the measurement period.

|  Scenario Name | Concurrent Users | Message Size (Bytes) | Back-end Service Delay (ms) | Error % | Throughput (Requests/sec) | Average Response Time (ms) | Standard Deviation of Response Time (ms) | 99th Percentile of Response Time (ms) | Ballerina GC Throughput (%) | Average Ballerina Memory Footprint After Full GC (M) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
|  10th Fibonacci Number | 100 | 50 | -1 | 0 | 19828.56 | 5 | 9.31 | 31 | 99.04 |  |
|  10th Fibonacci Number | 300 | 50 | -1 | 0 | 21151.12 | 14.13 | 9.11 | 42 | 97.55 |  |
|  10th Fibonacci Number | 1000 | 50 | -1 | 0 | 19703.31 | 50.68 | 14.82 | 98 | 91.86 |  |
|  20th Fibonacci Number | 100 | 50 | -1 | 0 | 628.42 | 159.15 | 116.58 | 485 | 97.37 | 21.682 |
|  20th Fibonacci Number | 300 | 50 | -1 | 0 | 650.93 | 461.18 | 171.41 | 907 | 95.24 | 27.773 |
|  20th Fibonacci Number | 1000 | 50 | -1 | 0 | 635.53 | 1570.46 | 178.87 | 2039 | 94.99 | 61.164 |
|  30th Fibonacci Number | 100 | 50 | -1 | 0 | 5.29 | 18524.77 | 1407.72 | 21375 | 98.83 |  |
|  30th Fibonacci Number | 300 | 50 | -1 | 100 | 9.52 | 30016 | 0 | 30079 | 98.75 |  |
|  30th Fibonacci Number | 1000 | 50 | -1 | 100 | 31.72 | 30016 | 0 | 30079 | 98.31 |  |