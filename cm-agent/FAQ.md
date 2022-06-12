# cloudera-manager-agent FAQ

## 1. Errors & Solved

### 1.1 Error when starting `cm-agent` container: `Failed! trying again in 2 second(s): No supervisor config present`

```txt
[12/Jun/2022 12:51:10 +0000] 9 MainThread supervisor   INFO     Trying to connect to supervisor (Attempt 5)
[12/Jun/2022 12:51:10 +0000] 9 MainThread supervisor   ERROR    Failed! trying again in 2 second(s): No supervisor config present
Traceback (most recent call last):
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/supervisor.py", line 136, in connect
    obj = cls(cfg, os_ops_obj)
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/supervisor.py", line 83, in __init__
    raise SupervisorError("No supervisor config present")
SupervisorError: No supervisor config present
[12/Jun/2022 12:51:10 +0000] 9 MainThread agent        ERROR    Failed to connect to previous supervisor.
Traceback (most recent call last):
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/agent.py", line 2049, in find_or_start_supervisor
    self.connect_to_supervisor()
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/agent.py", line 2129, in connect_to_supervisor
    self.supervisor_client = SupervisorWrapper.connect(self.cfg, self.os_ops)
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/supervisor.py", line 145, in connect
    raise SupervisorError("Failed to connect to supervisor")
SupervisorError: Failed to connect to supervisor
[12/Jun/2022 12:51:10 +0000] 9 MainThread main         ERROR    Top-level exception: Failed to connect to supervisor
Traceback (most recent call last):
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/main.py", line 107, in main_impl
    ag.start(legacy_supervisor)
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/agent.py", line 828, in start
    self.find_or_start_supervisor(enable_supervisor_start)
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/agent.py", line 2049, in find_or_start_supervisor
    self.connect_to_supervisor()
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/agent.py", line 2129, in connect_to_supervisor
    self.supervisor_client = SupervisorWrapper.connect(self.cfg, self.os_ops)
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/supervisor.py", line 145, in connect
    raise SupervisorError("Failed to connect to supervisor")
SupervisorError: Failed to connect to supervisor
```

- ***Solve:*** This is usually caused by the wrong configuration file path in the mounted container. Note that since the container centos7 operation system uses the /var/run soft link to /run, in order to ensure compatibility, all paths should be mounted, includes: `/etc/cloudera-scm-agent/supervisord.conf:/etc/supervisord.conf` and `/etc/cloudera-scm-agent/supervisord.conf:/run/cloudera-scm-agent/supervisor/supervisord.conf`

- ***Debug suggestion:**

```bash
## Extract python scripts file to local.
docker run --rm \
--entrypoint /bin/sh wl4g/cloudera-manager-agent:6.3.1 \
-c "cat /opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/supervisor.py" > supervisor.py

## Edit add code for log prints.
vim +79 supervisor.py

## e.g:
print("============ Debug come on, self.supervisor_dir: =====" + self.supervisor_dir)

## Then, mount the supervisor.py that just added the debug log to start.
docker run -d \
--name cm-agent1 \
--network host \
--hostname $(hostname) \
--privileged \
-v /etc/cloudera-scm-agent/config.ini:/etc/cloudera-scm-agent/config.ini \
-v /etc/cloudera-scm-agent/supervisord.conf:/etc/supervisord.conf \
-v /etc/cloudera-scm-agent/supervisord.conf:/run/cloudera-scm-agent/supervisor/supervisord.conf \
-v /etc/default/cloudera-scm-agent:/etc/default/cloudera-scm-agent \
-v /mnt/disk1/log/cloudera-scm-agent/:/var/log/cloudera-scm-agent/ \
-v /run/cloudera-scm-agent/:/run/cloudera-scm-agent/ \
-v /opt/cloudera/csd/:/opt/cloudera/csd/ \
-v /opt/cloudera/parcel-cache/:/opt/cloudera/parcel-cache/ \
-v /opt/cloudera/parcels/:/opt/cloudera/parcels/ \
-v $(PWD)/supervisor.py:/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/supervisor.py
wl4g/cloudera-manager-agent:6.3.1
```

### 1.2 Error when starting `cm-agent` container: `Failed! trying again in 5 second(s): [Errno 111] Connection refused`

```txt
[11/Jun/2022 23:14:50 +0000] 1 MainThread supervisor   INFO     Trying to connect to supervisor (Attempt 5)
[11/Jun/2022 23:14:50 +0000] 1 MainThread supervisor   ERROR    Failed! trying again in 2 second(s): [Errno 111] Connection refused
Traceback (most recent call last):
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/supervisor.py", line 134, in connect
    obj = cls(cfg, os_ops_obj)
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/supervisor.py", line 89, in __init__
    self.identifier = self.__get_supervisor_identification()
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/util/__init__.py", line 531, in new_fn
    return fn(self, *args, **kwargs)
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/supervisor.py", line 372, in __get_supervisor_identification
    return self.client.supervisor.getIdentification()
  File "/usr/lib64/python2.7/xmlrpclib.py", line 1233, in __call__
    return self.__send(self.__name, args)
  File "/usr/lib64/python2.7/xmlrpclib.py", line 1592, in __request
    verbose=self.__verbose
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/supervisor/xmlrpc.py", line 460, in request
    self.connection.request('POST', handler, request_body, self.headers)
  File "/usr/lib64/python2.7/httplib.py", line 1057, in request
    self._send_request(method, url, body, headers)
  File "/usr/lib64/python2.7/httplib.py", line 1091, in _send_request
    self.endheaders(body)
  File "/usr/lib64/python2.7/httplib.py", line 1053, in endheaders
    self._send_output(message_body)
  File "/usr/lib64/python2.7/httplib.py", line 891, in _send_output
    self.send(msg)
  File "/usr/lib64/python2.7/httplib.py", line 853, in send
    self.connect()
  File "/usr/lib64/python2.7/httplib.py", line 834, in connect
    self.timeout, self.source_address)
  File "/usr/lib64/python2.7/socket.py", line 571, in create_connection
    raise err
error: [Errno 111] Connection refused
[11/Jun/2022 23:14:50 +0000] 1 MainThread agent        ERROR    Failed to connect to previous supervisor.
Traceback (most recent call last):
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/agent.py", line 2049, in find_or_start_supervisor
    self.connect_to_supervisor()
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/agent.py", line 2129, in connect_to_supervisor
    self.supervisor_client = SupervisorWrapper.connect(self.cfg, self.os_ops)
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/supervisor.py", line 143, in connect
    raise SupervisorError("Failed to connect to supervisor")
SupervisorError: Failed to connect to supervisor
[11/Jun/2022 23:14:50 +0000] 1 MainThread main         ERROR    Top-level exception: Failed to connect to supervisor
Traceback (most recent call last):
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/main.py", line 107, in main_impl
    ag.start(legacy_supervisor)
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/agent.py", line 828, in start
    self.find_or_start_supervisor(enable_supervisor_start)
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/agent.py", line 2049, in find_or_start_supervisor
    self.connect_to_supervisor()
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/agent.py", line 2129, in connect_to_supervisor
    self.supervisor_client = SupervisorWrapper.connect(self.cfg, self.os_ops)
  File "/opt/cloudera/cm-agent/lib/python2.7/site-packages/cmf/supervisor.py", line 143, in connect
    raise SupervisorError("Failed to connect to supervisor")
SupervisorError: Failed to connect to supervisor
[11/Jun/2022 23:14:50 +0000] 1 Dummy-1 agent        INFO     Stopping agent...
```

- ***Solve:*** This is usually caused by a failure to start the supervisored service, then the cause of its failure may be the configuration file in container: `/etc/supervisord.conf` and `/run/cloudera-scm-agent/supervisor/supervisord.conf` are incorrect, etc. (The path mapped to the host is: `/etc/cloudera-scm-agent/supervisord.conf`), Or Or due to the incompatibility of the `/docker-entrypoint.sh` start script using `exec+&` to process signals bugs.

## 2. Other

- 2.1 If **cm-agent** starts normally, the process tree should basically look like this:

```txt
[root@cdh6-worker-1 supervisor]# ps -ef|grep python
root       880     1  0 20:14 ?        00:00:09 /usr/bin/python2 /opt/cloudera/cm-agent/bin/../bin/supervisord -n
root       881     1  0 20:14 ?        00:01:42 /usr/bin/python2 /opt/cloudera/cm-agent/bin/cm agent
root      1337   880  0 20:14 ?        00:00:00 /usr/bin/python2 /opt/cloudera/cm-agent/bin/../bin/cmf-listener -l /var/log/cloudera-scm-agent/cmf_listener.log /var/run/cloudera-scm-agent/events
root      1351   880  1 20:14 ?        00:03:07 /usr/bin/python2 /opt/cloudera/cm-agent/bin/../bin/cm status_server
root      1583   880  0 20:16 ?        00:00:45 /usr/bin/python2 /opt/cloudera/cm-agent/bin/../bin/flood
zookeep+  1634   880  0 20:17 ?        00:00:01 /usr/bin/python2 /opt/cloudera/cm-agent/bin/cm proc_watcher 1662
hdfs      1635   880  0 20:17 ?        00:00:01 /usr/bin/python2 /opt/cloudera/cm-agent/bin/cm proc_watcher 1660
hbase     1659  1636  0 20:17 ?        00:00:00 /usr/bin/python2 /opt/cloudera/cm-agent/bin/cm redactor --fds 3 5
zookeep+  1663  1634  0 20:17 ?        00:00:00 /usr/bin/python2 /opt/cloudera/cm-agent/bin/cm redactor --fds 3 5
...
```
