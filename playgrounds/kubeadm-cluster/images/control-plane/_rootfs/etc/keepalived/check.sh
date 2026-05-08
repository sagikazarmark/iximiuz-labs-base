#!/bin/bash

# Check if kube-apiserver is listening on localhost:6443
curl --max-time 2 https://$(hostname):6443/healthz --cacert /etc/kubernetes/pki/ca.crt | grep -q 'ok'

# Return 0 if healthy, 1 otherwise
exit $?
