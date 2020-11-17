## agenda

#### Discourse.org Overview 

https://www.discourse.org/

https://github.com/discourse/discourse/blob/master/docs/DEVELOPER-ADVANCED.md


#### Why Discourse?



Clean and Modern Architecture


#### Deploy Discousre using docker-compose

```
version: '2'
services:
  postgresql:
    image: 'docker.io/bitnami/postgresql:11-debian-10'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - 'postgresql_data:/bitnami/postgresql'
  redis:
    image: 'docker.io/bitnami/redis:6.0-debian-10'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - 'redis_data:/bitnami'
  discourse:
    image: 'docker.io/bitnami/discourse:2-debian-10'
    ports:
      - '80:3000'
    depends_on:
      - postgresql
      - redis
    volumes:
      - 'discourse_data:/bitnami'
    environment:
      - POSTGRESQL_HOST=postgresql
      - POSTGRESQL_ROOT_USER=postgres
      - POSTGRESQL_CLIENT_CREATE_DATABASE_NAME=bitnami_application
      - POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME=bn_discourse
      - POSTGRESQL_CLIENT_CREATE_DATABASE_PASSWORD=bitnami1
      - DISCOURSE_POSTGRESQL_NAME=bitnami_application
      - DISCOURSE_POSTGRESQL_USERNAME=bn_discourse
      - DISCOURSE_POSTGRESQL_PASSWORD=bitnami1
      - DISCOURSE_HOSTNAME=www.example.com
  sidekiq:
    image: 'docker.io/bitnami/discourse:2-debian-10'
    depends_on:
      - discourse
    volumes:
      - 'discourse_data:/bitnami'
    command: 'nami start --foreground discourse-sidekiq'
    environment:
      - DISCOURSE_POSTGRESQL_NAME=bitnami_application
      - DISCOURSE_POSTGRESQL_USERNAME=bn_discourse
      - DISCOURSE_POSTGRESQL_PASSWORD=bitnami1
      - DISCOURSE_HOST=discourse
      - DISCOURSE_PORT=3000
      - DISCOURSE_HOSTNAME=www.example.com
volumes:
  postgresql_data:
    driver: local
  redis_data:
    driver: local
  discourse_data:
    driver: local
```    

### Docker Redis

https://github.com/bitnami/bitnami-docker-redis/blob/master/docker-compose.yml

```

version: '2'

services:
  redis:
    image: 'docker.io/bitnami/redis:6.0-debian-10'
    environment:
      # ALLOW_EMPTY_PASSWORD is recommended only for development.
      - ALLOW_EMPTY_PASSWORD=yes
      - REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL
    ports:
      - '6379:6379'
    volumes:
      - 'redis_data:/bitnami/redis/data'

volumes:
  redis_data:
    driver: local
```



`kompose convert`

Lesson Learn


PVC
Deployment
Service


#### Postgres 

Do similar for Postgres https://github.com/bitnami/bitnami-docker-postgresql


### Discourse app

https://github.com/bitnami/bitnami-docker-discourse


Convert Discourse to Kube using Kompose

`kompose convert`

Output:

```
discourse-deployment.yaml
discourse-service.yaml
dockercompose-discourse-data-persistentvolumeclaim.yaml
dockercompose-postgresql-data-persistentvolumeclaim.yaml
dockercompose-redis-data-persistentvolumeclaim.yaml
postgresql-deployment.yaml
redis-deployment.yaml
sidekiq-deployment.yaml
```


Setup PVC

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  creationTimestamp: null
  labels:
    io.kompose.service: dockercompose-redis-data
  name: dockercompose-redis-data
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 100Mi
status: {}
```

Redis Deployment

```
cat redis-deployment.yaml 
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    kompose.cmd: kompose convert -f ../docker-compose/docker-compose.yml
    kompose.version: 1.21.0 ()
  creationTimestamp: null
  labels:
    io.kompose.service: redis
  name: redis
spec:
  replicas: 1
  selector:
    matchLabels:
      io.kompose.service: redis
  strategy:
    type: Recreate
  template:
    metadata:
      annotations:
        kompose.cmd: kompose convert -f ../docker-compose/docker-compose.yml
        kompose.version: 1.21.0 ()
      creationTimestamp: null
      labels:
        io.kompose.service: redis
    spec:
      containers:
      - name: redis
        image: localhost:5000/bitnami/redis:6.0-debian-10
        imagePullPolicy: ""
        env:
          - name: ALLOW_EMPTY_PASSWORD
            value: "yes"
        resources: {}
        volumeMounts:
        - mountPath: /bitnami
          name: dockercompose-redis-data
      restartPolicy: Always
      serviceAccountName: ""
      volumes:
      - name: dockercompose-redis-data
        persistentVolumeClaim:
          claimName: dockercompose-redis-data
status: {}
```

Discourse

```
spec:
      containers:
      - name: discourse
        image: localhost:5000/bitnami/discourse:2-debian-10
        imagePullPolicy: ""
        env:

          - name: POSTGRESQL_HOST
            value: 172.17.0.22
          - name: POSTGRESQL_ROOT_USER
            value: postgres
          - name: REDIS_HOST
            value: 172.17.0.21
        ports:
        - containerPort: 3000
```      

Wait. What is `POSTGRESQL_HOST`

```
          - name: POSTGRESQL_HOST
            value: 172.17.0.22
```            

Display Pod IP

`kubectl get pods -l io.kompose.service=postgresql -o wide`

`minikube addons enable registry`
 
`docker tag busybox:latest localhost:5000/busybox`
`docker push localhost:5000/busybox`

 Run a foreground command

 `kubectl run -i --tty busybox --image=localhost:5000/busybox -- sh`


Run a psql to check postgres

kubectl run -i --tty psql --image=alpine:3.12 -- sh

https://github.com/tmaier/docker-postgresql-client/blob/master/Dockerfile

```
FROM alpine:3.12
RUN apk add --no-cache postgresql-client
ENTRYPOINT [ "psql" ]
```


Expose Public

https://kubernetes.io/docs/tutorials/kubernetes-basics/expose/expose-interactive/

https://kubernetes.io/docs/tutorials/kubernetes-basics/expose/expose-intro/





#### Ingress

https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  rules:
    - host: hello-world.info
      http:
        paths:
            - path: /
            pathType: Prefix
            backend:
                service:
                name: web
                port:
                    number: 8080
            - path: /v2
                pathType: Prefix
                backend:
                service:
                    name: web2
                    port:
                    number: 8080

```                  


Discourse Ingress

```
spec:
  rules:
    - host: www.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: discourse
                port:
                  number: 3000
```                  


#### Expose Redis/Postgres as Service

```
apiVersion: v1
kind: Service
metadata:
  annotations:
    kompose.cmd: kompose convert -f ../docker-compose/docker-compose.yml
    kompose.version: 1.21.0 ()
  creationTimestamp: null
  labels:
    io.kompose.service: redis
  name: redis
spec:
  type: ClusterIP
  ports:
    - name: redis
      port: 6379
      targetPort: 6379
  selector:
    io.kompose.service: redis
```    

or postgres

```
apiVersion: v1
kind: Service
metadata:
  annotations:
    kompose.cmd: kompose convert -f ../docker-compose/docker-compose.yml
    kompose.version: 1.21.0 ()
  creationTimestamp: null
  labels:
    io.kompose.service: postgresql
  name: postgresql
spec:
  type: ClusterIP
  ports:
    - name: postgresql
      port: 5432
      targetPort: 5432
  selector:
    io.kompose.service: postgresql

```

discourse-deployment.yaml will be

```
          - name: POSTGRESQL_HOST
            value: postgresql
          - name: REDIS_HOST
            value: redis
```            

#### Secrets and ConfigMap

Before:

redis-deployment.yaml

```
          - name: DISCOURSE_POSTGRESQL_PASSWORD
            value: bitnami1
```


After:

```

---
# Source: discourse/charts/postgresql/templates/secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: postgresql
  labels:
    io.kompose.service: postgresql
type: Opaque
data:
  postgresql-postgres-password: "Yml0bmFtaQ=="
  discourse-postgresql-password: "dEVUTEh4eW8wdA=="
```  

and
```
          - name: DISCOURSE_POSTGRESQL_PASSWORD
            valueFrom:
              secretKeyRef:
                name: postgresql
                key: discourse-postgresql-password
```                

ConfigMap

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: redis-health
  namespace: "default"
  labels:
    app: redis
    chart: redis-11.2.3
    heritage: Helm
    release: RELEASE-NAME
```    

```
      volumes:
      - name: dockercompose-redis-data
        persistentVolumeClaim:
          claimName: dockercompose-redis-data
      - name: health
        configMap:
          name: redis-health
          defaultMode: 0755
```          
Liveness & Readiness


```
        readinessProbe:
          initialDelaySeconds: 5
          periodSeconds: 5
          timeoutSeconds: 2
          successThreshold: 1
          failureThreshold: 5
          exec:
            command:
              - sh
              - -c
              - /health/ping_readiness_local.sh 1  
```

