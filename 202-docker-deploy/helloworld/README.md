
#### Create cloudbuild.yml

```
steps:
- name: 'gcr.io/cloud-builders/gcloud'
  args:
  - 'run'
  - 'deploy'
  - 'qs-image'
  - '--image'
  - 'gcr.io/peerless-trees-291001/quickstart-image'
  - '--region'
  - 'asia-southeast1'
  - '--platform'
  - 'managed'
  - '--allow-unauthenticated'

```

#### Run:
`gcloud builds submit --config cloudbuild.yaml`


Output:

```
Deploying container to Cloud Run service [qs-image] in project [peerless-trees-291001] region [asia-southeast1]
Deploying new service...
Setting IAM Policy......................................done
Creating Revision...........................................failed
Deployment failed
ERROR: (gcloud.run.deploy) Cloud Run error: Container failed to start. Failed to start and then listen on the port defined by the PORT environment variable. Logs for this revision might contain more information.

Logs URL:
https://console.cloud.google.com/logs/viewer?project=peerless-trees-291001&resource=cloud_run_revision/service_name/qs-image/revision_name/qs-image-00001-qop&advancedFilter=resource.type%3D%22cloud_run_revision%22%0Aresource.labels.service_name%3D%22qs-image%22%0Aresource.labels.revision_name%3D%22qs-image-00001-qop%22
ERROR
ERROR: build step 0 "gcr.io/cloud-builders/gcloud" failed: step exited with non-zero status: 1
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ERROR: (gcloud.builds.submit) build 6e739b42-1184-4c6f-acb9-08509562e293 completed with status "FAILURE"
```

Check logs `https://console.cloud.google.com/logs/viewer?project=peerless-trees-291001&resource=cloud_run_revision/service_name/qs-image/revision_name/qs-image-00001-qop&advancedFilter=resource.type%3D%22cloud_run_revision%22%0Aresource.labels.service_name%3D%22qs-image%22%0Aresource.labels.revision_name%3D%22qs-image-00001-qop%22`

```
2020-11-03 15:42:37.065 ICT
Hello, world! The time is Tue Nov 3 08:42:37 UTC 2020.
Warning
2020-11-03 15:42:37.321 ICT
Container called exit(0).
```
This container is run and exit


#### Use case 2 - Use a prebuilt image


Create cloudbuild2.yml with content

```
steps:
- name: 'gcr.io/cloud-builders/gcloud'
  args:
  - 'run'
  - 'deploy'
  - 'cloudrunservice'
  - '--image'
  - 'gcr.io/gcbdocs/hello'
  - '--region'
  - 'asia-southeast1'
  - '--platform'
  - 'managed'
  - '--allow-unauthenticated'

```

#### run

`gcloud builds submit --config cloudbuild2.yaml`

will see similar output

```
FETCHSOURCE
Fetching storage object: gs://peerless-trees-291001_cloudbuild/source/1604393212.081476-5807af06cdcc470f8feacd7f7cb8bfb1.tgz#1604393213380707
Copying gs://peerless-trees-291001_cloudbuild/source/1604393212.081476-5807af06cdcc470f8feacd7f7cb8bfb1.tgz#1604393213380707...
/ [1 files][  1.1 KiB/  1.1 KiB]                                                
Operation completed over 1 objects/1.1 KiB.                                      
BUILD
Already have image (with digest): gcr.io/cloud-builders/gcloud
Deploying container to Cloud Run service [cloudrunservice] in project [peerless-trees-291001] region [asia-southeast1]
Deploying new service...
Setting IAM Policy......................................done
Creating Revision..............................................done
Routing traffic.....done
Done.
Service [cloudrunservice] revision [cloudrunservice-00001-cip] has been deployed and is serving 100 percent of traffic.
Service URL: https://cloudrunservice-aod2srj6sq-as.a.run.app
PUSH
DONE
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ID                                    CREATE_TIME                DURATION  SOURCE                                                                                               IMAGES  STATUS
835dfadc-79bf-43d6-87cc-fc3ea14a42e5  2020-11-03T08:46:53+00:00  22S       gs://peerless-trees-291001_cloudbuild/source/1604393212.081476-5807af06cdcc470f8feacd7f7cb8bfb1.tgz  -       SUCCESS
```

It succeed and we'll have following endpoint `Service URL: https://cloudrunservice-aod2srj6sq-as.a.run.app`



#### Testing

`curl https://cloudrunservice-aod2srj6sq-as.a.run.app`

Hello World!


#### References

https://cloud.google.com/cloud-build/docs/quickstart-deploy


#### Troubleshoot

