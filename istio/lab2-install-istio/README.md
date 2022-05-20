
# Setup Istio

First step is to download, install and configure Istio.

## Download Istio

From <a href="https://istio.io">Istio.io</a> download Istio latest release
```
$ curl -L https://Istio.io/downloadIstio | sh -
$ cd istio-1.13.4
```



## Install Istio
### IstioCTL
First we need to install the ``istioctl``
```
$ sudo cp bin/istioctl /usr/local/bin
$ sudo chmod a+x /usr/local/bin/istioctl
```

### Deploy Istio
```
$ istioctl install --manifests=manifests --profile=demo
```

wait for the installation to complete and check the Istio services
```
$ kubectl get ns istio-system
$ kubectl get svc -n istio-services
$ kubectl get pods -n istio-services
```

### Kiali and Jaeger
We would like to install additional components like kiali and Jaeger 

```
$ kubectl install samples/addons/
$ kubecctl get svc -n istio-system
```

## Determining the ingress IP and ports

```
export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export TCP_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="tcp")].port}')

```

## Label your namespace
Add `istio-injection=enabled` label to your namespace.

```
kubectl label namespace default istio-injection=enabled
```
