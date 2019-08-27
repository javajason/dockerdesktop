            def scan_result_response = httpRequest acceptType: 'APPLICATION_JSON', authentication: DOCKER_REGISTRY_CREDENTIALS_ID, httpMode: 'GET', ignoreSslErrors: true, responseHandle: 'LEAVE_OPEN', url: "${DOCKER_REGISTRY_URI}/api/v0/imagescan/repositories/${DOCKER_IMAGE_NAMESPACE}/${DOCKER_IMAGE_REPOSITORY_DEV}/${DOCKER_IMAGE_TAG}"
            scan_result = readJSON text: scan_result_response.content

            if (scan_result.size() != 1) {
                println('Response: ' + scan_result)
                error('More than one imagescan returned, please narrow your search parameters')
            }

            scan_result = scan_result[0]

            if (!scan_result.check_completed_at.equals("0001-01-01T00:00:00Z")) {
                scanning = false
            } else {
                sleep 15
            }

        }
        println('Response JSON: ' + scan_result)
    }

    stage('Promote') {
        httpRequest acceptType: 'APPLICATION_JSON', authentication: DOCKER_REGISTRY_CREDENTIALS_ID, contentType: 'APPLICATION_JSON', httpMode: 'POST', ignoreSslErrors: true, requestBody: "{\"targetRepository\": \"${DOCKER_IMAGE_NAMESPACE}/${DOCKER_IMAGE_REPOSITORY_PROD}\", \"targetTag\": \"${DOCKER_IMAGE_TAG}\"}", responseHandle: 'NONE', url: "${DOCKER_REGISTRY_URI}/api/v0/repositories/${DOCKER_IMAGE_NAMESPACE}/${DOCKER_IMAGE_REPOSITORY_DEV}/tags/${DOCKER_IMAGE_TAG}/promotion"
    }

    stage('Deploy') {
        withEnv(["DOCKER_APPLICATION_FQDN=${DOCKER_APPLICATION_FQDN}",
                 "DOCKER_REGISTRY_HOSTNAME=${DOCKER_REGISTRY_HOSTNAME}",
                 "DOCKER_IMAGE_NAMESPACE=${DOCKER_IMAGE_NAMESPACE}",
                 "DOCKER_IMAGE_REPOSITORY_PROD=${DOCKER_IMAGE_REPOSITORY_PROD}",
                 "DOCKER_IMAGE_TAG=${DOCKER_IMAGE_TAG}",
                 "DOCKER_USER_CLEAN=${DOCKER_USER_CLEAN}"
                 ]) {

            if(DOCKER_ORCHESTRATOR.toLowerCase() == "kubernetes"){
                println("Deploying to Kubernetes")
                withEnv(["DOCKER_KUBE_CONTEXT=${DOCKER_KUBE_CONTEXT}", "DOCKER_KUBERNETES_NAMESPACE=${DOCKER_KUBERNETES_NAMESPACE}"]) {
                    sh 'envsubst < kubernetes.yaml | kubectl --context=${DOCKER_KUBE_CONTEXT} --namespace=${DOCKER_KUBERNETES_NAMESPACE} apply -f -'
                }
            }
            else if (DOCKER_ORCHESTRATOR.toLowerCase() == "swarm"){
                println("Deploying to Swarm")
                withEnv(["DOCKER_UCP_COLLECTION_PATH=${DOCKER_UCP_COLLECTION_PATH}"]) {
                    withDockerServer([credentialsId: DOCKER_UCP_CREDENTIALS_ID, uri: DOCKER_UCP_URI]) {
                        sh "docker stack deploy -c docker-compose.yml ${DOCKER_STACK_NAME}"
                    }
                }
            }
        }
    }
