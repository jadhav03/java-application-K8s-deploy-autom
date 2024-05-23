pipeline {
    agent any
    
    tools{
        jdk "jdk17"
        maven "maven3"
    }
    
    environment {
        SCANNER_HOME = tool "sonar"
    }

    stages {
        stage('Git Checkout') {
            steps {
              git branch: 'main', url: 'https://github.com/jadhav03/game'
            }
        }
    
    
    
        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }
    
    
  
        stage('Run Test Cases') {
            steps {
                sh "mvn test"
            }
        }
   
    
    
        stage('SoanarQube Analysis') {
            steps {
                script{
                withSonarQubeEnv('sonar') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName = boardGame -Dsonar.projectKey = boardGame \
                           -Dsonar.java.binaries = . '''
                }  }
            }
        }

    
   
        stage('Quality Gate') {
            steps {
                script{
                    waitForQualityGate abortPipeline: false, credentialsID: "sonar-token"
                }
            }
        }
 
    
    
        stage('Build') {
            steps {
                sh "mvn package"
            }
        }
        
        stage('Publish Artifact to Nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'Global-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                    sh "mvn deploy"    
                }
            }
        }
        
        stage('Build and Tag Image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                       sh "docker build -f bjadhav22/mavenapp:latest ."
                    }
                }
            }
        }
        
         stage('Push Image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                       sh "docker push  bjadhav22/mavenapp:latest ."
                    }
                }
            }
        }

    }
}
