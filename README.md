# docker-cloudera-manager

A Docker image built on the customized [Cloudera Manager](https://www.cloudera.com/content/www/en-us/products/cloudera-manager.html) 6.x

> Tip: In this project, cloudera-manager is deployed in docker container, but because CM itself does not support containerization, for example, **CM Server** manages **CM agent** through ssh and relies on supervisord to manage CDH component processes, which may violate the The principle of containerization, **stateless** + **not depends ssh** + **easy auto-scaling** services should be the best at containerized deployment. This may not fully utilize the advantages of containerization, but just use it as a **VM + auto script**. , but have to admit that it still takes advantage of one-click deployment (this is only the deployment phase of the software life cycle).

## Quick Start

- [cm-server docs](cm-server/README.md)

- [cm-agent docs](cm-agent/README.md)
