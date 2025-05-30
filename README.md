# K3d setup
## Prerequisites
- Have docker engine running
- Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/)
- Install [helm](https://helm.sh/docs/intro/install/)
- Install [skaffold](https://skaffold.dev/docs/install/)
- Install [k3d Client](https://k3d.io/#installation)
- Create Cluster using this [config](../k3d.yaml)
```
k3d cluster create --config k3d.yaml
```
You should get something like this:
```
INFO[0000] Using config file k3d.yaml (k3d.io/v1alpha5#simple)
INFO[0000] portmapping '8199:80' targets the loadbalancer: defaulting to [servers:*:proxy agents:*:proxy]
INFO[0000] Prep: Network
INFO[0000] Re-using existing network 'k3d-sfogo-cluster' (df109c15d7c04a81d270ae1d216d062b2f0b7ae9bae61b95372293f94838758c)
INFO[0000] Created image volume k3d-sfogo-cluster-images
INFO[0000] Starting new tools node...
INFO[0000] Starting node 'k3d-sfogo-cluster-tools'
INFO[0001] Creating node 'k3d-sfogo-cluster-server-0'
INFO[0001] Creating node 'k3d-sfogo-cluster-agent-0'
INFO[0001] Creating LoadBalancer 'k3d-sfogo-cluster-serverlb'
INFO[0001] Using the k3d-tools node to gather environment information
INFO[0001] Starting new tools node...
INFO[0001] Starting node 'k3d-sfogo-cluster-tools'
INFO[0002] Starting cluster 'sfogo-cluster'
INFO[0002] Starting servers...
INFO[0002] Starting node 'k3d-sfogo-cluster-server-0'
INFO[0005] Starting agents...
INFO[0005] Starting node 'k3d-sfogo-cluster-agent-0'
INFO[0008] Starting helpers...
INFO[0008] Starting node 'k3d-sfogo-cluster-serverlb'
INFO[0015] Injecting records for hostAliases (incl. host.k3d.internal) and for 4 network members into CoreDNS configmap...
INFO[0017] Cluster 'sfogo-cluster' created successfully!
INFO[0017] You can now use it like this:
kubectl cluster-info
```
## Start
```
skaffold run --tail
```

Available at [http://hostname.127.0.0.1.nip.io:8199/](http://hostname.127.0.0.1.nip.io:8199/)
Well Known OIDC Config [http://hostname.127.0.0.1.nip.io:8199/realms/master/.well-known/openid-configuration](http://hostname.127.0.0.1.nip.io:8199/realms/master/.well-known/openid-configuration)
