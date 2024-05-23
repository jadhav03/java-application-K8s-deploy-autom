pipeline {
    agent any
    
    tools{
        jdk "JDK17"
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
                    
                    sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=boardGame -Dsonar.projectKey=boardGame -Dsonar.sources=."
                           
                }  }
            }
        }

    
   
       // stage('Quality Gate') {
         //   steps {
           //     script{
             //       waitForQualityGate abortPipeline: false, credentialsID: "sonar-token"
               // }
            //}
        //}
 
    
    
        stage('Build') {
            steps {
                sh "mvn clean package"
                
            }
        }
        
        stage('Publish Artifact to Nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'Global-settings', jdk: 'JDK17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                    sh "mvn deploy"    
                }
            }
        }
        
        stage('Build and Tag Image') {
            steps {
                script{
                    
                    docker.build("bjadhav22/mavenapp:latest", ".")
                    
                    // This step should not normally be used in your script. Consult the inline help for details.
                   //withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                     //  sh "ls -l"
                     //  sh "docker build -f bjadhav22/mavenapp:latest game/Dockerfile"
   
                    
                    //withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                      // sh "ls -l"
                       //sh "docker build -f bjadhav22/mavenapp:latest ."
                    //}
                }
            }
        }
        
        stage('Push Image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                       sh "docker push bjadhav22/mavenapp:latest"
                    }
                }
            }
        }
        
        stage('Deploy K8s') {
            steps {
                    withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'k8s-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://10.0.1.7:6443') {
                        sh 'kubectl apply -f deployment-service.yaml'
                    }
                }
        }
        
        
        stage('Check Deployment') {
            steps {
                    withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'k8s-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://10.0.1.7:6443') {
                        sh 'kubectl get pods -n webapps'
                        sh 'kubectl get svc -n webapps'
                    }
            }
        }

        
    }
}
