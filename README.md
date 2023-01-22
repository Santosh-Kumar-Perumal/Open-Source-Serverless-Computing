# knative-serving
Demonstrate Knative serving

# Install Knative Components

## 1.1 Set up Knative Serving Resources

Create the `serving` namespace

```
kubectl create namespace serving
```

Install Knative Serving Components ( CRDs and Core Components) [serving-components.yaml](./serving/serving-components.yaml) file

```
kubectl apply -f serving/serving-components.yaml
```

Check if Knative Serving Core Components are up-and-running

```
kubectl get pods -n serving
```

## 1.2 Set up KNative Eventing Resources

Create the `eventing` namespace

```
kubectl create namespace eventing
```

Install Knative Eventing Components ( CRDs and Core Components )  [eventing-components.yaml](./eventing/eventing-components.yaml) file

```
kubectl apply -f eventing/eventing-components.yaml
```

Check if Knative Eventing Core Components are up-and-running

```
kubectl get pods -n eventing
```

# Set up Istio

## 1.1 Install `istioctl` version `1.12`

Follow the steps presented here
```
https://istio.io/latest/docs/setup/getting-started/#download
```

Check if the proper version has been installed

```
istioctl version
```
## 1.2 Install `Istio`

```
istioctl install -y
```

## 1.3 Deploy `Istio Resources` ( [istio-resources.yaml](./istio/istio-resources.yaml) )
```
kubectl apply -f istio/istio-resources.yaml
```

## 1.4 Check `Istio setup`

```
kubectl get pods -n istio-system
```



# Deploying HTTP Workloads using Knative Serving

## 1.1 Creating Knative Services

Create a new file called [knative-service.yaml](./knative-service.yaml)

Paste in the following text:

```
apiVersion: serving.knative.dev/v1 
kind: Service
metadata:
  name: serving-app 
  namespace: default 
spec:
  template:
    spec:
      containers:
        - image: bsucaciu/knative-serving:v1
```

Deploy Knative Service

```
kubectl apply -f knative-service.yaml
```

Check if the service has been deployed

```
kubectl get ksvc
```

## 1.2 Access the newly created Knative Service

Add a new entry to hosts file

```
Unix: /etc/hosts
Windows: C:\Windows\System32\drivers\etc\hosts
```

Entry value
```
127.0.0.1       serving-app.default.example.com
```

Open your preferred web browser and navigate to:
```
http://serving-app.default.example.com
```


## 2.1 Scalling to zero

Default Global Config
```
kubectl describe configmap config-autoscaler -n serving
```

```
apiVersion: v1
kind: ConfigMap
metadata:
 name: config-autoscaler
 namespace: serving
data:
 enable-scale-to-zero: "true"
 scale-to-zero-grace-period: "30s"
 scale-to-zero-pod-retention-period: "0s"
 container-concurrency-target-default: "100"
 container-concurrency-target-percentage: "0.7"
 max-scale-up-rate: "1000"
 max-scale-down-rate: "2"
 panic-window-percentage: "10"
 panic-threshold-percentage: "200"
 stable-window: "60s"
 target-burst-capacity: "200"
 requests-per-second-target-default: "200"
```

Check the number of running pods
```
kubectl get pods
```

Apply the new configuration
```
kubectl apply -f config-autoscaler.yaml
```

## 3.1 Managing revisions

Inspect current revision(s)

```
kubectl get revision
```

Edit the [knative-service.yaml](./knative-service.yaml) file by appending the following configuration
```
          env:
            - name: MESSAGE
              value: Hello
```

Apply the updated Knative Service
```
kubectl apply -f knative-service.yaml
```

Inspect current revisions

```
kubectl get revision
```

Change the image version
```
        - image: bsucaciu/knative-serving:v2
```

Inspect current revisions

```
kubectl get revision
```

## 3.3 Working with Subroutes

Display current route configuration

```
kubectl get routes 
```

Split traffic accross revisions
```
  traffic:
    - revisionName: serving-app-00001
      percent: 50
    - revisionName: serving-app-00002
      percent: 50
```

Apply the updated Knative Service
```
kubectl apply -f knative-service.yaml
```

Use different domains to access specific revision(s)
```
  traffic:
    - revisionName: serving-app-00001
      percent: 50
    - revisionName: serving-app-00002
      percent: 50
    - revisionName: serving-app-00003
      percent: 0
      tag: test
```

Apply the updated Knative Service
```
kubectl apply -f knative-service.yaml
```

Add a new entry to hosts file

```
Unix: /etc/hosts
Windows: C:\Windows\System32\drivers\etc\hosts
```

Entry value
```
127.0.0.1       test-serving-app.default.example.com
```

## 3.3 Clean up Knative Services

Delete revision

```
kubectl delete revision serving-app-00001
```

Delete Knative Service

```
kubectl delete ksvc serving-app
```


