{{- define "hello-world.name" -}}
{{- .Chart.Name }}
{{- end }}

{{- define "hello-world.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "hello-world.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "hello-world.labels" -}}
helm.sh/chart: {{ include "hello-world.chart" . }}
{{ include "hello-world.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "hello-world.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hello-world.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
