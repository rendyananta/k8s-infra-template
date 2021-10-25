.PHONY:
	ops.up
	ops.down
	env.up
	env.down

ops.up:
	echo "preparing namespaces.."
	kubectl create namespace ops
	echo "updating helm repository.."
	helm repo add jenkins https://charts.jenkins.io
	helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
	helm repo update
	echo "installing jenkins.."
	kubectl -n ops apply -f jenkins/kube-resources
	helm -n ops upgrade --install jenkins-ci jenkins/jenkins -f jenkins/values.yaml
	echo "installing sonarqube.."
	kubectl -n ops apply -f sonarqube/kube-resources
	helm -n ops upgrade --install sonarqube sonarqube/sonarqube -f sonarqube/values.yaml

ops.down:
	echo "uninstalling jenkins.."
	helm -n ops uninstall jenkins-ci
	kubectl -n ops delete -f jenkins/kube-resources
	echo "uninstalling sonarqube.."
	helm -n ops uninstall sonarqube
	kubectl -n ops delete -f sonarqube/kube-resources

env.up:

env.down:

