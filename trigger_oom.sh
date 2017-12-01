#!/bin/bash

curl -X POST \
  -F token=${oom_token} \
  -F ref=${oom_ref_name} \
  -F "variables[pod]=${pod}" \
  -F "variables[scenario]=${scenario}" \
  -F "variables[openstack_creds]=${openstack_creds}" \
https://gitlab.forge.orange-labs.fr/api/v4/projects/7221/trigger/pipeline