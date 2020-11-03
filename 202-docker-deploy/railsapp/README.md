Pull image that we pushed in docker-105
See https://github.com/pilgrim2go/rails-4-docker/blob/deploy/docker-compose.mount.yml


`docker pull pilgrim2go/railsapp:deploy`

Tag docker image to GCR

 `docker tag pilgrim2go/railsapp:deploy gcr.io/peerless-trees-291001/railsapp:deploy`
 
Then Push
 `docker push gcr.io/peerless-trees-291001/railsapp:deploy`

Then Deploy

`gcloud beta run deploy railsapp-004 --image gcr.io/peerless-trees-291001/railsapp:deploy --region asia-southeast1`
 
Note we might need to set env

`gcloud beta run deploy railsapp-004 --image gcr.io/peerless-trees-291001/railsapp:deploy --region asia-southeast1 --set-env-vars RAILS_ENV=production --set-env-vars SECRET_KEY_BASE=0699b17f4a5665a6ec03e180d74d0e78a0f2db6b929c61d0f15a5f1fe39831911bc72cc36f43cc9f805e76c2a440a70d365d78c1173766f836631f78b04fc5b1`
 
curl https://railsapp-004-aod2srj6sq-as.a.run.app
