## Custom helm chart for nginx installation

1. Nginx is installed with this helm chart and it is exposed using nodeport.

2. Config map has been created with the custom ngix configuration.

3. Configmap has been mapped to the nginx deployment by using volume and volume mounts .

# steps for verifying after cloning the repo

1. helm install "chartname" nginx-custom
    > This creates deployment ,configmap and exposes the service
   
2. upgrading the chart after any custom nginx config upgradations.
   " helm upgrade "chartname" "nginx-custom"

Verify the nginx installation using "curl http://minikube-ip:nodePort"
