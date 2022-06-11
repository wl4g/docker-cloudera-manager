#!/bin/bash
# Copyright 2017 ~ 2025 the original author or authors. <wanglsir@gmail.com, 983708408@qq.com>
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
set -e

if [ "$1" = 'start' ]; then
  DB_CONFIG_FILE=/etc/cloudera-scm-server/db.properties

  if [[ "$CM_DB_CONFIG" != "" ]]; then
      cp -f $CM_DB_CONFIG $DB_CONFIG_FILE
  fi

  /opt/cloudera/cm/bin/cm-server-pre
  /opt/cloudera/cm/bin/cm-server
else
  exec "$@"
fi