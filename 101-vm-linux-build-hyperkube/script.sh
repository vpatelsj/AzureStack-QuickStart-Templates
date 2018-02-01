set -e

echo "Starting Kubernetes Build Deployment..."
date

echo "Running as:"
whoami

sleep 20
#############
# Parameters
#############
MINIKUBELINK=${1}
KUBECTLLINK=${2}
DOCKERLINK=${3}
REPOLINK=${4}
REPOBRANCH=${5}
DOCKERHUBUSERNAME=${6}
DOCKERHUBPASSWORD=${7}
DOCKERHUBREPONAME=${8}
HYPERKUBEVERSION=${9}
#############
# Retry Function
#############
retrycmd_if_failure() { for i in 1 2 3 4 5; do $@; [ $? -eq 0  ] && break || sleep 5; done ; }

echo "downloading minikube binary"
retrycmd_if_failure sudo curl -Lo minikube $MINIKUBELINK && sudo chmod +x minikube && sudo mv minikube /usr/local/bin/

echo "downloading kubectl binary"
retrycmd_if_failure sudo curl -Lo kubectl $KUBECTLLINK && sudo chmod +x kubectl &&  sudo mv kubectl /usr/local/bin/

echo "update the system"
retrycmd_if_failure sudo apt-get -y update

echo "add docker repo key"
retrycmd_if_failure sudo curl -fsSL $DOCKERLINK/gpg | sudo apt-key add -

echo "add docker repo" 
sudo add-apt-repository "deb [arch=amd64] $DOCKERLINK $(lsb_release -cs) stable"

echo "re-update the system"
retrycmd_if_failure sudo apt-get -y update

echo "install docker"
retrycmd_if_failure sudo apt-get -y install docker-ce

echo "checkout git project"
mkdir kubernetes
cd kubernetes
git clone $REPOLINK
cd kubernetes
git fetch
git checkout -b $REPOBRANCH origin/$REPOBRANCH

echo "build kubernetes"
retrycmd_if_failure  sudo build/run.sh make
cd cluster/images/hyperkube

echo "install make"
retrycmd_if_failure sudo apt-get install make

echo "build hyperkube image"
retrycmd_if_failure sudo make VERSION=$HYPERKUBEVERSION ARCH=amd64

echo "login to dockerhub"
retrycmd_if_failure sudo docker login --username $DOCKERHUBUSERNAME --password $DOCKERHUBPASSWORD

echo "retag hyperkube image"
retrycmd_if_failure sudo docker tag gcr.io/google-containers/hyperkube-amd64:$HYPERKUBEVERSION $DOCKERHUBUSERNAME/$DOCKERHUBREPONAME:$HYPERKUBEVERSION

echo "push hyperkube image to docker hub"
retrycmd_if_failure sudo docker push $DOCKERHUBUSERNAME/$DOCKERHUBREPONAME:$HYPERKUBEVERSION

echo "Kubernetes Build Deployment completed. Image pushed to $DOCKERHUBUSERNAME/$DOCKERHUBREPONAME:$HYPERKUBEVERSION"
