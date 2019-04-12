# podd
Project Description
----------------------------------------
The Power-capping for Dependent Distributed Applications (PoDD)  
is a a hierarchical, distributed, dynamic power management system  
as a power limiting approach for dependent(coupled) applications  
in large-scale systems. It maxes the overall performance of coupled  
applications while strictly respecting system-level power budget  
during application runtime.  

Dependency
----------------------------------------
A bare-metal cluster with NSF setup  
Intel power capping technique RAPL support  
Intel PCM(Processor Counter Monitor) support  
Numactl linux utility  
Pagemigrates linux utility  
Taskset linux utility  
Numpy 1.8.0  
Sklearn 0.17  
Other libraries dependecies(required by applications)  

Running PoDD Examples
----------------------------------------
Single line launcher:  
python controller.py <application_1> <application_2> <power_cap> <host_IP> <test_flag>  
This is the command to launch coupled application with PoDD.  
controller.py is the highest level wrapper, also containing core logics  
for PoDD.  
<application_1> <application_2> are the coupled applications to run.  
<power_cap> is the power budget per node, i.g. system power budget / number of nodes.  
<host_IP> is the controller server IP, where PoDD should be launched from.  
<test_flag> indicates whether to run in a test mode.  
For high level structure of the system, please refer to our paper  
--PoDD: Power-capping Dependent Distributed Applications.  
For details, please check the comments in the source codes.  

Build:
Most of the source is written in python and bash.  
RAPL tools build naively with gcc:  
Go under the PoDD/tool/RAPL  
$ make  
Check out the README file under the RAPL sub-directory for the usage of those tools.  
Pre-trained classifer needs to be built with responding python source.

Additional Notes:  
Unfortunately, the code has been written in a manner highly dependent on  
the system for sake of simplicity. Most of the paths in the source and  
script need to be modified. The RAPL wrapper we use also needs to be modified  
according to the system platform.


Benchmarks
----------------------------------------
PoDD requires no code instrumentation, thus, we only provides the benchmark  
suite name and version here:

For coupled apps:  
Gadget 2.0.7: galaxy, cluster -- https://wwwmpa.mpa-garching.mpg.de/gadget/  
Lulesh -- https://computation.llnl.gov/projects/co-design/lulesh  
Parall-kmeans -- http://www.ece.northwestern.edu/~wkliao/Kmeans/index.html 
VisIt 2.10.0 -- https://wci.llnl.gov/simulation/computer-codes/visit  
Pigz -- https://zlib.net/pigz/  
Spark 2.2 -- https://spark.apache.org  
Spark-bench -- https://codait.github.io/spark-bench/  

For single apps(used as trainning data for classifier):  
Gadget 2.0.7  
Parsec 3.0 -- https://parsec.cs.princeton.edu/  
Rodinia 3.1 -- http://lava.cs.virginia.edu/Rodinia  
NU-MineBench 3.0.1 -- http://cucis.ece.northwestern.edu/projects/DMS/MineBench.html 

Directory Structure  
----------------------------------------  
.  
├── run       -- Exmaple scripts of running applications  
├── tool      -- RAPL and pcm tool  
├── source    -- Source files  
├── scripts   -- Scripts used to setup our cluster  
└── data      -- Data collected  
