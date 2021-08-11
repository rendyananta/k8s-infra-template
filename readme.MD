# Provisioning command
-- need to be automated later.

## Install Longhorn (Storage Class by Rancher)
```sh
helm repo add longhorn https://charts.longhorn.io
helm repo update
kubectl create namespace longhorn-system
helm install longhorn longhorn/longhorn --namespace longhorn-system
```

## Install Jenkins

```sh
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm upgrade --install jenkins-ci jenkins/jenkins -f jenkins/values.yaml
```

## Install Sonarqube
```sh
cd sonarqube/chart/charts/sonarqube
helm dependency update
kubectl create namespace sonarqube
cd ../../../../
helm upgrade --install -f sonarqube/values.yaml sonarqube ./sonarqube/chart/charts/sonarqube/
```