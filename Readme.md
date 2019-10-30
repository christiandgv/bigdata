# create base hadoop cluster docker image
docker build -f Dockerfile -t christiandgv/hadoop-cluster-base:latest .

# create master node hadoop cluster docker image
docker build -f master/Dockerfile -t christiandgv/hadoop-cluster-master:latest master

