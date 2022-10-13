#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

git submodule update --init

ARGOCD_VER=latest # 2.4.14
ARGOWF_VER=latest # 3.4.1
CODER_VER=0.9.5
FLUX_VER=0.35.0
HELM_VER=3.10.0
ISTIO_VER=1.14.4
KUBECOLOR_VER=0.0.20
KUBECTL_VER=stable
KUBENAV_VER=latest # 3.9.0
KUSTOMIZE_VER=4.5.5
SEALEDSECRETS_VER=0.18.5
TERRAFORM_VER=1.3.2
TERRAGRUNT_VER=latest
WEAVE_VER=latest # 0.9.6

# Housekeeping:
BINDIR="${HOME}/bin"
COMPLETIONDIR="${HOME}/.config/fish/completion"
LARCH=$(dpkg --print-architecture)
if [ "${LARCH}" == "amd64" ]; then
  ALTARCH="$(uname -m)"
else
  ALTARCH="${LARCH}"
fi

# Helpers

function fetch-url() {
  # fetch-url https://git.io/binary-latest
  printmsg "$1"
  curl -fsSL "${1}"
}

function untar() {
  # untar $HOME/bin ./file-here
  tar xC "${1}" "${2}"
}

function fetch-ungz() {
  # fetch-ungz https://bin.io/binary-linux.gz > $HOME/bin/binary
  fetch-url "${1}" | gunzip -
}

function fetch-untgz() {
  # fetch-untgz https://git.io/binary.tgz $HOME/bin ./binary
  fetch-ungz "${1}" | untar "${2}" "${3}"
}

function fetch-untar() {
  # fetch-untar https://git.io/binary.tgz $HOME/bin ./binary
  fetch-url "${1}" | untar "${2}" "${3}"
}

function fetch-unzip() {
  # fetch-unzip https://git.me/binary.zip ${BINDIR}/binary
  fetch-url "${1}" | gunzip - >"${2}" && chmod +x "${2}"
}

function printmsg() {
  echo "$*" >/dev/stderr
}

mkdir -p "${BINDIR}" "${COMPLETIONDIR}" || true

if [ ! -x "${BINDIR}/kubectl" ]; then
  printmsg "======================="
  printmsg "Kubectl ${KUBECTL_VER}"
  fetch-url "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/${KUBECTL_VERSION}.txt)/bin/linux/${LARCH}/kubectl" >"${BINDIR}/kubectl" && chmod +x "${BINDIR}/kubectl"
  if [ ! -f "${COMPLETIONDIR}/kubectl.fish" ]; then
    "${BINDIR}/kubectl" completion fish >"${COMPLETIONDIR}/kubectl.fish"
  fi
fi
if [ ! -x "${BINDIR}/kubecolor" ]; then
  printmsg "======================="
  printmsg "Kubecolor ${KUBECOLOR_VER}"
  fetch-untgz "https://github.com/hidetatz/kubecolor/releases/download/v${KUBECOLOR_VER}/kubecolor_${KUBECOLOR_VER}_Linux_${ALTARCH}.tar.gz" "${BINDIR}" kubecolor
fi
if [ ! -x "${BINDIR}/argocd" ]; then
  printmsg "======================="
  printmsg "ArgoCD ${ARGOCD_VER}"
  fetch-url "https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-${LARCH}" >"${BINDIR}/argocd" && chmod +x "${BINDIR}/argocd"
fi
if [ ! -x "${BINDIR}/argo" ]; then
  printmsg "Argo Workflows ${ARGOWF_VER}"
  fetch-unzip "https://github.com/argoproj/argo-workflows/releases/latest/download/argo-linux-${LARCH}.gz" "${BINDIR}/argo"
fi
if [ ! -x "${BINDIR}/flux" ]; then
  printmsg "======================="
  printmsg "Flux v${FLUX_VER}"
  fetch-untgz "https://github.com/fluxcd/flux2/releases/download/v${FLUX_VER}/flux_${FLUX_VER}_linux_${LARCH}.tar.gz" "${BINDIR}" flux
  if [ ! -f "${COMPLETIONDIR}/flux" ]; then
    "${BINDIR}/flux" completion fish >"${COMPLETIONDIR}/flux.fish"
  fi
fi
if [ ! -x "${BINDIR}/coder" ]; then
  printmsg "======================="
  printmsg "Coder ${CODER_VER}"
  fetch-untgz "https://github.com/coder/coder/releases/download/v${CODER_VER}/coder_${CODER_VER}_linux_${LARCH}.tar.gz" "${BINDIR}" ./coder
  if [ ! -f "${COMPLETIONDIR}/coder" ]; then
    "${BINDIR}/coder" completion fish >"${COMPLETIONDIR}/coder.fish"
  fi
fi
if [ ! -x "${BINDIR}/kubeseal" ]; then
  printmsg "======================="
  printmsg "Kubeseal ${SEALEDSECRETS_VER}"
  fetch-untgz "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${SEALEDSECRETS_VER}/kubeseal-${SEALEDSECRETS_VER}-linux-${LARCH}.tar.gz" "${BINDIR}" kubeseal
fi
if [ ! -x "${BINDIR}/istioctl" ]; then
  printmsg "======================="
  printmsg "Istio ${ISTIO_VER}"
  fetch-untgz "https://github.com/istio/istio/releases/download/${ISTIO_VER}/istioctl-${ISTIO_VER}-linux-${LARCH}.tar.gz" "${BINDIR}" istioctl
  if [ ! -f "${COMPLETIONDIR}/istioctl" ]; then
    "${BINDIR}/istioctl" completion fish >"${COMPLETIONDIR}/istioctl.fish"
  fi
fi
if [ ! -x "${BINDIR}/kustomize" ]; then
  printmsg "======================="
  printmsg "Kustomize ${KUSTOMIZE_VER}"
  fetch-untgz "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VER}/kustomize_v${KUSTOMIZE_VER}_linux_${LARCH}.tar.gz" "${BINDIR}" kustomize
  if [ ! -f "${COMPLETIONDIR}/kustomize" ]; then
    "${BINDIR}/kustomize" completion fish >"${COMPLETIONDIR}/kustomize.fish"
  fi
  printmsg "======================="
fi
if [ ! -x "${BINDIR}/gitops" ]; then
  printmsg "======================="
  printmsg "Gitops ${WEAVE_VER}"
  fetch-untgz "https://github.com/weaveworks/weave-gitops/releases/latest/download/gitops-linux-${ALTARCH}.tar.gz" "${BINDIR}" gitops
  if [ ! -f "${COMPLETIONDIR}/gitops" ]; then
    "${BINDIR}/gitops" completion fish >"${COMPLETIONDIR}/gitops.fish"
  fi
fi
if [ ! -x "${BINDIR}/terraform" ]; then
  printmsg "======================="
  printmsg "Terraform ${TERRAFORM_VER}"
  fetch-unzip "https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_${LARCH}.zip" "${BINDIR}/terraform"
fi
if [ ! -x "${BINDIR}/terragrunt" ]; then
  printmsg "======================="
  printmsg "Terragrunt ${TERRAGRUNT_VER}"
  fetch-url "https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_${LARCH}" >"${BINDIR}/terragrunt" && chmod +x "${BINDIR}/terragrunt"
fi
if [ ! -x "${BINDIR}/helm" ]; then
  printmsg "======================="
  # Helm is kinda special. Files are in a subdir.
  printmsg "Helm ${HELM_VER}"
  fetch-untgz "https://get.helm.sh/helm-v${HELM_VER}-linux-${LARCH}.tar.gz" "${BINDIR}" "linux-${LARCH}/helm" &&
    command mv -f "${BINDIR}/linux-${LARCH}/helm" "${BINDIR}/helm" && rmdir "${BINDIR}/linux-${LARCH}"
  if [ ! -f "${COMPLETIONDIR}/helm" ]; then
    "${BINDIR}/helm" completion fish >"${COMPLETIONDIR}/helm.fish"
  fi
fi

./update.sh -f
