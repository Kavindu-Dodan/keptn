#!/bin/bash

source ./openshift/installationFunctions.sh
source ./common/utils.sh

# Create keptn namespaces
kubectl apply -f ../manifests/keptn/namespace.yaml
verify_kubectl $? "Creating keptn namespace failed."

# configure the host path volume plugin
oc apply -f ../manifests/openshift/oc-scc-hostpath.yaml
verify_kubectl $? "Deploying hostpath SCC failed."
oc patch scc hostpath -p '{"allowHostDirVolumePlugin": true}'
# verify_install_step "Patching hostpath plugin failed."
oc adm policy add-scc-to-group hostpath system:authenticated
#verify_install_step "Creating hostpath SCC failed."

# Install logging
print_info "Installing Logging"
kubectl apply -f ../manifests/logging/namespace.yaml
kubectl apply -f ../manifests/logging/monitoring.yaml
verify_kubectl $? "Creating ElasticSearch deployment failed."
kubectl apply -f ../manifests/logging/fluent-bit/service-account.yaml
verify_kubectl $? "Creating fluent-bit service account failed."
oc adm policy add-scc-to-user privileged -z fluent-bit -n knative-monitoring
kubectl apply -f ../manifests/logging/fluent-bit/role.yaml
verify_kubectl $? "Creating fluent-bit role failed."
kubectl apply -f ../manifests/logging/fluent-bit/role-binding.yaml
verify_kubectl $? "Creating fluent-bit role binding failed."
kubectl apply -f ../manifests/logging/fluent-bit/configmap.yaml
verify_kubectl $? "Creating fluent-bit configmap failed."
kubectl apply -f ../manifests/logging/fluent-bit/ds.yaml
verify_kubectl $? "Creating fluent-bit daemonset failed."

oc adm policy add-scc-to-user anyuid -z istio-egressgateway-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-citadel-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-ingressgateway-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-cleanup-old-ca-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-mixer-post-install-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-mixer-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-pilot-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-sidecar-injector-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-galley-service-account -n istio-system

# Install Istio service mesh
print_info "Installing Istio"
./common/setupIstio.sh
verify_install_step $? "Installing Istio failed."
print_info "Installing Istio done"

wait_for_all_pods_in_namespace "istio-system"

oc expose svc istio-ingressgateway -n istio-system

# Install monitoring
#oc adm policy add-scc-to-user privileged -z elasticsearch-logging -n knative-monitoring
#oc adm policy add-scc-to-user anyuid system:serviceaccount:knative-monitoring:fluentd-ds
#oc adm policy add-scc-to-user privileged system:serviceaccount:knative-monitoring:fluentd-ds
#kubectl label nodes --all beta.kubernetes.io/fluentd-ds-ready="true"
#verify_kubectl $? "Labelling nodes failed."
#kubectl apply -f ../manifests/knative/monitoring.yaml
#verify_kubectl $? "Applying knative monitoring components failed."
#wait_for_all_pods_in_namespace "knative-monitoring"

# Install tiller for helm
print_info "Installing Tiller"
kubectl apply -f ../manifests/tiller/tiller.yaml
helm init --service-account tiller
print_info "Installing Tiller done"
oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:kube-system:tiller

# Install keptn core services - Install keptn channels
print_info "Installing keptn"
./openshift/setupKeptn.sh
verify_install_step $? "Installing keptn failed."
print_info "Installing keptn done"

# Install keptn services
print_info "Wear uniform"
./common/wearUniform.sh
verify_install_step $? "Installing keptn's uniform failed."
print_info "Keptn wears uniform"

# Install additional keptn services for openshift
print_info "Wear Openshift uniform"
./openshift/wearUniform.sh
verify_install_step $? "Installing keptn's Openshift uniform failed."
print_info "Keptn wears Openshift uniform"

# Install done
print_info "Installation of keptn complete."

# Retrieve keptn endpoint and api-token
KEPTN_ENDPOINT=https://api.keptn.$(kubectl get cm -n keptn keptn-domain -oyaml | yq - r data.app_domain)
KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -o=yaml | yq - r data.keptn-api-token | base64 --decode)

print_info "keptn endpoint: $KEPTN_ENDPOINT"
print_info "keptn api-token: $KEPTN_API_TOKEN"