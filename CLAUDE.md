# CLAUDE.md — devsecops-helm

GitHub repo: `Illumidragui/devsecops-helm`

Helm charts for all workloads deployed by ArgoCD. Each subdirectory is one ArgoCD Application.
ArgoCD watches this repo's `main` branch and auto-syncs on every push.

## Chart directory map

| Directory | Purpose | Namespace |
|---|---|---|
| `cert-manager-clusterissuer/` | cert-manager + Let's Encrypt ClusterIssuer | `cert-manager` |
| `ingress-nginx/` | ingress-nginx controller + AWS NLB | `ingress-nginx` |
| `tailscale-operator/` | Tailscale in-cluster operator | `tailscale-operator` |
| `syesite-chart/` | Portfolio site (Docusaurus) | `syepsite` |
| `hello-world/` | GitOps smoke-test (nginx + static HTML) | `hello-world` |
| `kuberflow/` | Status page — confirms sync + shows deploy architecture (nginx + static HTML) | `kuberflow` |

## Lint commands

```bash
# Lint a single chart
helm lint hello-world

# Lint all charts (matches CI)
helm lint ingress-nginx cert-manager-clusterissuer tailscale-operator syesite-chart hello-world kuberflow

# Charts with upstream dependencies — update first
helm dependency update cert-manager-clusterissuer && helm lint cert-manager-clusterissuer
helm dependency update ingress-nginx && helm lint ingress-nginx
helm dependency update tailscale-operator && helm lint tailscale-operator
```

## Adding a new chart

1. Create `<chart-name>/Chart.yaml`, `values.yaml`, `templates/`
2. Add `<chart-name>` to the `for chart in ...` lint loop in `.github/workflows/ci-fast.yml` and `ci-pr.yml`
3. Add the application entry to `argocd-app-of-apps/values.yaml` (separate repo)
4. Push to `dev`, open PR to `main` — ArgoCD picks it up after merge

## Updating the syesite image tag

The `syesite-chart/values.yaml` `image.tag` field is updated automatically by the CI pipeline
(`_reusable.deploy-kubernetes.yml`). Do not change it manually during normal operations.
Format: `ga-YYYY.MM.DD-HHMM`

## hello-world chart

This is a configmap-based nginx chart — no Docker image build needed.
Edit `hello-world/values.yaml` to change the HTML content.
Useful to verify:
- ArgoCD sync is working
- ingress-nginx is routing correctly
- The cluster is healthy after a fresh bootstrap

## kuberflow chart

Same configmap-based nginx pattern as `hello-world` — no Docker image build needed.
Served at `kuberflow.shengjunye.me` (DNS record lives in `devsecops-infra/dns.tf`).
Edit `kuberflow/values.yaml`'s `html` block to change the page; it's styled to match
`website/src/styles/custom.css`'s "Operator" theme (same fonts/colors), so if that
theme changes, update this chart's inline `<style>` to match.
