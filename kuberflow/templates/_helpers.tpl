{{- define "kuberflow.name" -}}
{{- .Chart.Name }}
{{- end }}

{{- define "kuberflow.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "kuberflow.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "kuberflow.labels" -}}
helm.sh/chart: {{ include "kuberflow.chart" . }}
{{ include "kuberflow.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "kuberflow.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kuberflow.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
