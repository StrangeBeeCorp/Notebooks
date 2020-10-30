# Notebooks

Few jupyter notebooks are shared to help managing maintenance tasks for TheHive and Cortex with Elasticsearch database.

- Backup indexes: helps creating snapshots of indexes of TheHive and Cortex
- Restore indexes: helps restoring snapshots of TheHive and Cortex indexes
- Migration index created with ES5 to ES7: helps with the migration of indexes created with Elasticsearch 5.x and get them ready to upgrade to Elasticsearch 7.x. Useful to install Cortex 3.1.0 and TheHive 3.5.0.
- Delete index: delete specific index.


## Requirements

`jq` application is required. And Jupyter kernel for Bash is required to run these notebooks. 

```
pip3 install jupyterlab
pip3 install bash_kernel
python3 -m bash_kernel.install
```