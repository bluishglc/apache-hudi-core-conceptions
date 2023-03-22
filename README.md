# Apache Hudi Core Conceptions

A set of notebooks to explore and explain core conceptions of Apache Hudi, such as file layouts, file sizing, compaction, clustering and so on.

1. The notebooks manipulate a public dataset: amazon-reviews-pds, the location is s3://amazon-reviews-pds, it is accessible on aws global regions, for China regions or non aws users, you can download it to local with S3 client tools. 

2. The running environment of notebooks is Amazon EMR Studio, a managed notebook service for Amazon EMR. If you have no aws accounts, you can modify notebooks to adapt to a notebook environment which supports Spark kernal.

3. The recommended configuration for Spark cluster is: 32 vCore，120GB or higher, the master node must have 100GB+ free disk space.