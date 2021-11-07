.PHONY:
	ops.up
	ops.down
	env.init
	env.mysql.up
	env.mysql.down
	env.postgresql.up
	env.postgresql.down

ops.up:
	echo "updating helm repository.."
	helm repo add jenkins https://charts.jenkins.io
	helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
	helm repo update
	echo "installing jenkins.."
	kubectl -n ops apply -f jenkins/kube-resources
	helm -n ops upgrade --install --create-namespace jenkins-ci jenkins/jenkins -f jenkins/values.yaml
	echo "installing sonarqube.."
	kubectl -n ops apply -f sonarqube/kube-resources
	helm -n ops upgrade --install --create-namespace sonarqube sonarqube/sonarqube -f sonarqube/values.yaml

ops.down:
	echo "uninstalling jenkins.."
	helm -n ops uninstall jenkins-ci
	kubectl -n ops delete -f jenkins/kube-resources
	echo "uninstalling sonarqube.."
	helm -n ops uninstall sonarqube
	kubectl -n ops delete -f sonarqube/kube-resources

env.init:
	echo "updating helm repository.."
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update

env.mysql.up: env.init
	echo "installing mysql.."
	helm -n database upgrade --install --create-namespace mysql bitnami/mysql --set auth.rootPassword=secretpassword

env.mysql.down:
	echo "uninstalling mysql.."
	helm -n database uninstall mysql

env.postgresql.up: env.init
	echo "installing postgresql.."
	helm -n database upgrade --install --create-namespace postgresql bitnami/postgresql --set auth.rootPassword=secretpassword

env.postgresql.down:
	echo "uninstalling postgresql.."
	helm -n database uninstall postgresql

