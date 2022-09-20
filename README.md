# CouchDB使用地理空间索引

使用CouchDB用来存储geojson和地理空间索引。

Fork From [kontrollanten](https://github.com/kontrollanten)/**[couchdb-hastings-docker](https://github.com/kontrollanten/couchdb-hastings-docker)**。

使用[cloudant-labs](https://github.com/cloudant-labs)的[hastings](https://github.com/cloudant-labs/hastings)和[easton](https://github.com/cloudant-labs/easton)来创建地理空间数据索引。

CouchDB官方[文档](https://docs.couchdb.org/en/3.1.1/)。

cloudant关于GeoSpatial的[介绍文档](https://cloud.ibm.com/docs/Cloudant?topic=Cloudant-cloudant-nosql-db-geospatial)以及[api文档](https://cloud.ibm.com/apidocs/cloudant#getgeo)。

构建docker的[镜像地址](https://hub.docker.com/r/xaotuman/couchdb-hastings-3.1.1)。

关于docker构建的[文档](docs/构建docker.md)。

关于docker使用的[文档](docs/docker使用.md)。

**注意**：本文档采用的CouchDB版本为 3.1.1，并作为主分支，如果想要2.3.1版本的，可以将分支切换到2.3.1。那个分支没有说明文档，基本上是fork过来稍微改了一下。
