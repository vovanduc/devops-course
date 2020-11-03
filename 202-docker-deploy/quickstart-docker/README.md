### Build using Dockerfile
Cloud Build allows you to build a Docker image using a Dockerfile. You don't require a separate Cloud Build config file.

To build using a Dockerfile:

Get your Cloud project ID by running the following command:

`PROJECT_ID=$(gcloud config get-value project)`

Run the following command from the directory containing quickstart.sh and Dockerfile, where project-id is your Cloud project ID:

`gcloud builds submit --tag gcr.io/$PROJECT_ID/quickstart-image`


Output:

```
Creating temporary tarball archive of 4 file(s) totalling 1.5 KiB before compression.
Uploading tarball of [.] to [gs://peerless-trees-291001_cloudbuild/source/1604392602.145817-51f6ffda71f04e4994c0c0aa10c39f6c.tgz]
Created [https://cloudbuild.googleapis.com/v1/projects/peerless-trees-291001/builds/66c9f681-b227-473d-82f0-f4fe739fa45b].
Logs are available at [https://console.cloud.google.com/cloud-build/builds/66c9f681-b227-473d-82f0-f4fe739fa45b?project=852634297415].
----------------------------------------------------------------------------------------------------------------------------------------------------- REMOTE BUILD OUTPUT ------------------------------------------------------------------------------------------------------------------------------------------------------
starting build "66c9f681-b227-473d-82f0-f4fe739fa45b"

FETCHSOURCE
Fetching storage object: gs://peerless-trees-291001_cloudbuild/source/1604392602.145817-51f6ffda71f04e4994c0c0aa10c39f6c.tgz#1604392603539963
Copying gs://peerless-trees-291001_cloudbuild/source/1604392602.145817-51f6ffda71f04e4994c0c0aa10c39f6c.tgz#1604392603539963...
/ [1 files][  951.0 B/  951.0 B]                                                
Operation completed over 1 objects/951.0 B.                                      
BUILD
Already have image (with digest): gcr.io/cloud-builders/docker
Sending build context to Docker daemon  6.144kB
Step 1/3 : FROM alpine
latest: Pulling from library/alpine
188c0c94c7c5: Pulling fs layer
188c0c94c7c5: Verifying Checksum
188c0c94c7c5: Download complete
188c0c94c7c5: Pull complete
Digest: sha256:c0e9560cda118f9ec63ddefb4a173a2b2a0347082d7dff7dc14272e7841a5b5a
Status: Downloaded newer image for alpine:latest
 ---> d6e46aa2470d
Step 2/3 : COPY quickstart.sh /
 ---> 5a00d73b2023
Step 3/3 : CMD ["/quickstart.sh"]
 ---> Running in a5452d65d82e
Removing intermediate container a5452d65d82e
 ---> 6284ec0df2e7
Successfully built 6284ec0df2e7
Successfully tagged gcr.io/peerless-trees-291001/quickstart-image:latest
PUSH
Pushing gcr.io/peerless-trees-291001/quickstart-image
The push refers to repository [gcr.io/peerless-trees-291001/quickstart-image]
72f4e4d311f2: Preparing
ace0eda3e3be: Preparing
ace0eda3e3be: Layer already exists
72f4e4d311f2: Pushed
latest: digest: sha256:42c96a2713eef6c43034bd7444fb592805e9d97a1cb5e411bdcc004d4efd73b7 size: 735
DONE
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ID                                    CREATE_TIME                DURATION  SOURCE                                                                                               IMAGES                                                   STATUS
66c9f681-b227-473d-82f0-f4fe739fa45b  2020-11-03T08:36:44+00:00  15S       gs://peerless-trees-291001_cloudbuild/source/1604392602.145817-51f6ffda71f04e4994c0c0aa10c39f6c.tgz  gcr.io/peerless-trees-291001/quickstart-image (+1 more)  SUCCESS


Updates are available for some Cloud SDK components.  To install them,
please run:
  $ gcloud components update

``` 



### Build using a build config file

In this section you will use a Cloud Build config file to build the same Docker image as above. The build config file instructs Cloud Build to perform tasks based on your specifications.

In the same directory that contains quickstart.sh and the Dockerfile, create a file named cloudbuild.yaml with the following contents. This file is your build config file. At build time, Cloud Build automatically replaces $PROJECT_ID with your project ID.

```

steps:
- name: 'gcr.io/cloud-builders/docker'
  args: [ 'build', '-t', 'gcr.io/$PROJECT_ID/quickstart-image', '.' ]
images:
- 'gcr.io/$PROJECT_ID/quickstart-image'

```

Start the build by running the following command:

`gcloud builds submit --config cloudbuild.yaml`


Output:
```
ID                                    CREATE_TIME                DURATION  SOURCE                                                                                               IMAGES                                                   STATUS
e699bdee-585b-478c-aeb0-f2ec56f4d1ad  2020-11-03T08:38:52+00:00  14S       gs://peerless-trees-291001_cloudbuild/source/1604392729.852908-a8c261538263481e8dc009ff40885fec.tgz  gcr.io/peerless-trees-291001/quickstart-image (+1 more)  SUCCESS
```

We'll have image endpoint like this `gcr.io/peerless-trees-291001/quickstart-image`


### References

https://cloud.google.com/cloud-build/docs/quickstart-build

