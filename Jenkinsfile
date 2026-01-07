pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:

  - name: python
    image: python:3.11-slim
    command: ["cat"]
    tty: true

  - name: sonar-scanner
    image: sonarsource/sonar-scanner-cli
    command: ["cat"]
    tty: true

  - name: kaniko
    image: gcr.io/kaniko-project/executor:latest
    args:
      - "--dockerfile=Dockerfile"
      - "--context=/workspace"
      - "--destination=${REGISTRY_URL}/${REGISTRY_REPO}/${APP_NAME}:${IMAGE_TAG}"
      - "--skip-tls-verify"
    volumeMounts:
      - name: kaniko-secret
        mountPath: /kaniko/.docker/
  volumes:
    - name: kaniko-secret
      secret:
        secretName: regcred
        items:
          - key: .dockerconfigjson
            path: config.json
'''
        }
    }

    environment {
        APP_NAME       = "quizapp"
        IMAGE_TAG      = "latest"

        REGISTRY_URL  = "nexus-service-for-docker-hosted-registry.nexus.svc.cluster.local:8085"
        REGISTRY_REPO = "quizapp"

        SONAR_PROJECT  = "quizapp"
        SONAR_HOST_URL = "http://my-sonarqube-sonarqube.sonarqube.svc.cluster.local:9000"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies & Run Tests') {
            steps {
                container('python') {
                    sh '''
                        python --version
                        pip install --upgrade pip
                        pip install -r requirements.txt
                        pytest --cov=. --cov-report=xml
                    '''
                }
            }
        }

        stage('Verify Coverage File') {
            steps {
                container('python') {
                    sh 'ls -l coverage.xml'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                container('sonar-scanner') {
                    withCredentials([
                        string(credentialsId: 'sonarqube_2401094', variable: 'SONAR_TOKEN')
                    ]) {
                        sh '''
                            sonar-scanner \
                              -Dsonar.projectKey=quizapp \
                              -Dsonar.host.url=$SONAR_HOST_URL \
                              -Dsonar.login=$SONAR_TOKEN \
                              -Dsonar.sources=quizapp \
                              -Dsonar.python.coverage.reportPaths=coverage.xml
                        '''
                    }
                }
            }
        }

        stage('Build & Push Image (Kaniko)') {
            steps {
                container('kaniko') {
                    sh '''
                        echo "Building & pushing image using Kaniko..."
                    '''
                }
            }
        }
    }
}
