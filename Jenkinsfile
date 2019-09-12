DOCKER_USER = "${env.BRANCH_NAME}"
DOCKER_USER_CLEAN = "${DOCKER_USER.replace(".", "")}"
// DOCKER_IMAGE_NAMESPACE = "se-${DOCKER_USER_CLEAN}"
DOCKER_IMAGE_NAMESPACE_DEV = "jasons-org"
DOCKER_IMAGE_NAMESPACE_PROD = "jasons-org-prod"
// DOCKER_IMAGE_REPOSITORY = "simple-nginx"
DOCKER_IMAGE_REPOSITORY = "jedemo"
// DOCKER_IMAGE_REPOSITORY_DEV = "${DOCKER_IMAGE_REPOSITORY}-dev"
// DOCKER_IMAGE_REPOSITORY_PROD = "${DOCKER_IMAGE_REPOSITORY}-prod"
// DOCKER_IMAGE_TAG = "${env.BUILD_TIMESTAMP}"
// DOCKER_IMAGE_TAG = "1.0"
DOCKER_IMAGE_TAG = "83-ee-alpine"

// Available orchestrators = [ "kubernetes" | "swarm" ]
DOCKER_ORCHESTRATOR = "kubernetes"

if(DOCKER_ORCHESTRATOR.toLowerCase() == "kubernetes"){
    DOCKER_KUBERNETES_NAMESPACE = "se-${DOCKER_USER_CLEAN}"

    // DOCKER_APPLICATION_FQDN = "simple-nginx.${DOCKER_USER_CLEAN}.${DOCKER_KUBE_DOMAIN_NAME}"
    // DOCKER_APPLICATION_FQDN = "jedemo.${DOCKER_USER_CLEAN}.${DOCKER_KUBE_DOMAIN_NAME}"
    DOCKER_APPLICATION_FQDN = "jedemo-web.${DOCKER_USER_CLEAN}.${DOCKER_KUBE_DOMAIN_NAME}"
}
else if (DOCKER_ORCHESTRATOR.toLowerCase() == "swarm"){
    DOCKER_SERVICE_NAME = "${DOCKER_USER_CLEAN}-${DOCKER_IMAGE_REPOSITORY}"
    DOCKER_STACK_NAME = "${DOCKER_USER_CLEAN}-simple-nginx"
    DOCKER_UCP_COLLECTION_PATH = "/Shared/Private/${DOCKER_USER}"

    // DOCKER_APPLICATION_FQDN = "simple-nginx.${DOCKER_USER_CLEAN}.${DOCKER_SWARM_DOMAIN_NAME}"
    DOCKER_APPLICATION_FQDN = "jedemo.${DOCKER_USER_CLEAN}.${DOCKER_SWARM_DOMAIN_NAME}"
}
else {
    error("Unsupported orchestrator")
}

node {
    def docker_image
/*
    stage('Validate Environment') {
        required_env = [ 'DOCKER_USER',
                         'DOCKER_IMAGE_NAMESPACE',
                         'DOCKER_IMAGE_REPOSITORY',
                         'DOCKER_IMAGE_REPOSITORY_DEV',
                         'DOCKER_IMAGE_REPOSITORY_PROD',
                         'DOCKER_IMAGE_TAG',
                         'DOCKER_REGISTRY_HOSTNAME',
                         'DOCKER_REGISTRY_URI',
                         'DOCKER_REGISTRY_CREDENTIALS_ID',
                         'DOCKER_UCP_URI',
                         'DOCKER_UCP_CREDENTIALS_ID',
                         'DOCKER_SERVICE_NAME' ]
        fail = 0
        required_env.each { required ->
            if(env[required] == null) {
                fail = 1
                echo "Missing required environment variable: '${required}'" 
            }
        }
        if(fail) {
            error("Missing required environment variables")
        }
    }
*/
    stage('Clone') {
        /* Let's make sure we have the repository cloned to our workspace */

 // TODO       checkout scm
    }

    stage('Build') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        // docker_image = docker.build("${DOCKER_IMAGE_NAMESPACE}/${DOCKER_IMAGE_REPOSITORY_DEV}")
// TODO        docker_image = docker.build("${DOCKER_IMAGE_NAMESPACE_DEV}/${DOCKER_IMAGE_REPOSITORY}")
    }

    stage('Test') {
        /* Ideally, we would run a test framework against our image.
         * For this example, we're using a Volkswagen-type approach ;-) */

// TODO        docker_image.inside {
// TODO            sh 'echo "Tests passed"'
// TODO        }
    }
    /* TODO
    stage('Push') {
        docker.withRegistry(DOCKER_REGISTRY_URI, DOCKER_REGISTRY_CREDENTIALS_ID) {
            docker_image.push(DOCKER_IMAGE_TAG)
        }
    }
    */
    /*
    stage('Scan') {
        httpRequest acceptType: 'APPLICATION_JSON', authentication: DOCKER_REGISTRY_CREDENTIALS_ID, contentType: 'APPLICATION_JSON', httpMode: 'POST', ignoreSslErrors: true, responseHandle: 'NONE', url: "${DOCKER_REGISTRY_URI}/api/v0/imagescan/scan/${DOCKER_IMAGE_NAMESPACE}/${DOCKER_IMAGE_REPOSITORY_DEV}/${DOCKER_IMAGE_TAG}/linux/amd64"

        def scan_result

        def scanning = true
        while(scanning) {
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
    */
    /*
    stage('Promote') {
        // httpRequest acceptType: 'APPLICATION_JSON', authentication: DOCKER_REGISTRY_CREDENTIALS_ID, contentType: 'APPLICATION_JSON', httpMode: 'POST', ignoreSslErrors: true, requestBody: "{\"targetRepository\": \"${DOCKER_IMAGE_NAMESPACE}/${DOCKER_IMAGE_REPOSITORY_PROD}\", \"targetTag\": \"${DOCKER_IMAGE_TAG}\"}", responseHandle: 'NONE', url: "${DOCKER_REGISTRY_URI}/api/v0/repositories/${DOCKER_IMAGE_NAMESPACE}/${DOCKER_IMAGE_REPOSITORY_DEV}/tags/${DOCKER_IMAGE_TAG}/promotion"
        httpRequest acceptType: 'APPLICATION_JSON', authentication: DOCKER_REGISTRY_CREDENTIALS_ID, contentType: 'APPLICATION_JSON', httpMode: 'POST', ignoreSslErrors: true, requestBody: "{\"targetRepository\": \"${DOCKER_IMAGE_NAMESPACE_PROD}/${DOCKER_IMAGE_REPOSITORY}\", \"targetTag\": \"${DOCKER_IMAGE_TAG}\"}", responseHandle: 'NONE', url: "${DOCKER_REGISTRY_URI}/api/v0/repositories/${DOCKER_IMAGE_NAMESPACE_DEV}/${DOCKER_IMAGE_REPOSITORY}/tags/${DOCKER_IMAGE_TAG}/promotion"
    }
    */

    stage('Deploy') {
        withEnv(["DOCKER_APPLICATION_FQDN=${DOCKER_APPLICATION_FQDN}",
                 "DOCKER_REGISTRY_HOSTNAME=${DOCKER_REGISTRY_HOSTNAME}",
                 // "DOCKER_IMAGE_NAMESPACE=${DOCKER_IMAGE_NAMESPACE}",
                 // "DOCKER_IMAGE_REPOSITORY_PROD=${DOCKER_IMAGE_REPOSITORY_PROD}",
                 "DOCKER_IMAGE_NAMESPACE=${DOCKER_IMAGE_NAMESPACE_PROD}",
                 "DOCKER_IMAGE_REPOSITORY_PROD=${DOCKER_IMAGE_REPOSITORY}",
                 "DOCKER_IMAGE_TAG=${DOCKER_IMAGE_TAG}",
                 "DOCKER_USER_CLEAN=${DOCKER_USER_CLEAN}"
                 ])
        {

            if(DOCKER_ORCHESTRATOR.toLowerCase() == "kubernetes"){
                println("Deploying to Kubernetes")
                println("\nKUBERNETES YAML FILE:")
                println("-------")
                sh 'cat kubernetes.yaml'
                println("-------")
                println("Image to be pulled from: ${DOCKER_REGISTRY_HOSTNAME}/${DOCKER_IMAGE_NAMESPACE}/${DOCKER_IMAGE_REPOSITORY_PROD}:${DOCKER_IMAGE_TAG}")
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
}
