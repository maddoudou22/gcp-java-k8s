pipeline {
	agent { 
        node {
			label 'jenkins-gcp-preemptible' // Label de flotte specifie dans la configuration du plugin Google Compute Engine
			 //def dateFormat = new SimpleDateFormat("yyyyMMddHHmm")
			 //def current_date = new Date()
		}
	}
	
	environment {
		//package_version = readMavenPom().getVersion()
		dockerRegistry = "devops.maddoudou.click:5000"
		dockerRepo = "gcp-java-k8s"
		applicationName = 'gcp-java-k8s' // Same as artifactId in pom.xml
		SONAR_ENDPOINT = "http://34.89.250.156:9000"
		SLAVE_LOCAL_MAVEN_DEPENDENCIES_DIRECTORY = "/home/jenkins/.m2"
		GCS_BUCKET_MAVEN_DEPENDENCIES = "gs://jenkins-gcp-preemptible/.m2"
		GCS_BUCKET_ARTEFACTS = "gs://jenkins-gcp-preemptible/artefacts/"
		//kubernetesNode = 'rancher.maddoudou.click'
		//deploymentConfigurationPathSource = "deploy-k8s" // Location of the K8s deployment configuration on the pipeline instance
		//deploymentConfigurationPathKubernetes = "/home/jenkins/k8s-deployments" // Location of the K8s deployment configuration on the K8s instace
    }
    stages {
	
		stage('Download dependencies from Cloud Storage') {
            steps {
				echo 'Get the cached maven dependencies from a GCS bucket ...'
				sh 'mkdir $SLAVE_LOCAL_MAVEN_DEPENDENCIES_DIRECTORY'
				sh 'gsutil -m cp -n -r $GCS_BUCKET_MAVEN_DEPENDENCIES/* $SLAVE_LOCAL_MAVEN_DEPENDENCIES_DIRECTORY'
			}
		}
		
        stage('Build') {
            steps {
                echo 'Building ...'
				//sh 'mvn -T 10 -Dmaven.test.skip=true clean install'
				sh 'mvn -T 10 -Dmaven.test.skip=true clean package'
            }
        }

/*		
		stage('Unit test') {
            steps {
                echo 'Unit testing ...'
				sh 'mvn -T 1C test'
            }
        }
*/

/*
		stage('OWASP - Dependencies check') {
            steps {
                echo 'Check OWASP dependencies ...'
				sh 'mvn dependency-check:check'
            }
        }
*/		

/*
		stage('Sonar - Code Quality') {
            steps {
                echo 'Check Code Quality ...'
				sh 'mvn sonar:sonar -Dsonar.host.url=$SONAR_ENDPOINT' // -Dsonar.dependencyCheck.reportPath=target/dependency-check-report.xml'
            }
        }
*/
		stage('Dependencies sync') {
            steps {
				echo 'Copying the maven dependencies to the GCS bucket ...'
				sh 'gsutil -m cp -n -r $SLAVE_LOCAL_MAVEN_DEPENDENCIES_DIRECTORY/* $GCS_BUCKET_MAVEN_DEPENDENCIES'
			}
        }
		
		stage('Artifacts upload') {
            steps {
				echo 'Copying the generated artefacts to a GCS bucket ...'
				//sh 'rm -rf target'
				echo '${current_date}'
				sh "mv target artefacts-\$(date +\"%Y%m%d%H%M%S\" | sed -e 's/\"//g')"
				sh 'gsutil -m cp -n -r artefacts-* $GCS_BUCKET_ARTEFACTS'
			}
        }

/*		
        stage('Bake') {
            steps {
                echo 'Building Docker image ...'
				sh 'docker build --rm --build-arg PACKAGE_VERSION=${package_version} --build-arg APPLICATION_NAME=${applicationName} -t ${dockerRegistry}/${dockerRepo}:${package_version} .'
				echo 'Removing dangling Docker image from the local registry ...'
				//sh "docker rmi $(docker images --filter "dangling=true" -q --no-trunc) 2>/dev/null"
				echo 'Publishing Docker image into the private registry ...'
				sh 'docker push ${dockerRegistry}/${dockerRepo}:${package_version}'
            }
        }
*/

/*
		stage('Deploy') {
            steps {
                echo 'Checking Kubernetes readiness ...'
				sh 'ssh -oStrictHostKeyChecking=no -i /var/lib/keys/ireland.pem ubuntu@${kubernetesNode} "kubectl get nodes"'
				echo 'Sending deployment configuration files to Kubernetes ...'
				sh 'pwd'
				sh 'scp -oStrictHostKeyChecking=no -i /var/lib/keys/ireland.pem ${deploymentConfigurationPathSource}/* ubuntu@${kubernetesNode}:${deploymentConfigurationPathKubernetes}/${applicationName}'
				//sh 'docker run -d -p 8088:8080 ${dockerRegistry}/${dockerRepo}:${package_version}'
            }
        }
*/
    }
}