#!/usr/bin/env bash

ARC_CONTROLLER_NAMESPACE="arc-systems"

function install_arc_controller() {
	helm upgrade --install arc \
		--namespace "${ARC_CONTROLLER_NAMESPACE}" \
		--create-namespace \
		--wait \
		oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller
}

ARC_RUNNER_SET_NAMESPACE="arc-runners"
ARC_GITHUB_PAT_SECRET_NAME="arc-github-secret"

function install_arc_runner_set() {
	RELEASE_NAME=arc-$(echo "${1,,}" | sed 's/\//-/g')-set
	GITHUB_CONFIG_URL="https://github.com/$1"
	helm upgrade --install "${RELEASE_NAME}" \
		--namespace "${ARC_RUNNER_SET_NAMESPACE}" \
		--create-namespace \
		--set githubConfigUrl="${GITHUB_CONFIG_URL}" \
		--set githubConfigSecret="${ARC_GITHUB_PAT_SECRET_NAME}" \
		--values gha-runner-scale-set-dind-fix.yaml \
		--wait \
		oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set
}

install_arc_controller
install_arc_runner_set "rust-sense"
install_arc_runner_set "jamezrin/MonaPaste"
install_arc_runner_set "jamezrin/timeit-webapp"
install_arc_runner_set "jamezrin/test-spring"
install_arc_runner_set "jamezrin/aylamusica-rails"
install_arc_runner_set "jamezrin/onthebuns-auto-campaigns"
