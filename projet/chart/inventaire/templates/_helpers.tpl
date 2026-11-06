{{/* Nom du chart */}}
{{- define "inventaire.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Nom complet de la release */}}
{{- define "inventaire.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "inventaire.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Nom d'un composant : inventaire-api, inventaire-frontend, inventaire-postgres
Usage : include "inventaire.componentName" (dict "ctx" . "component" "api")
*/}}
{{- define "inventaire.componentName" -}}
{{- printf "%s-%s" (include "inventaire.fullname" .ctx) .component | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Labels de sélection (stables, utilisés par les selectors) */}}
{{- define "inventaire.selectorLabels" -}}
app.kubernetes.io/name: {{ include "inventaire.name" .ctx }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{/* Labels communs à toutes les ressources */}}
{{- define "inventaire.labels" -}}
helm.sh/chart: {{ include "inventaire.chart" .ctx }}
{{ include "inventaire.selectorLabels" . }}
app.kubernetes.io/version: {{ .ctx.Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .ctx.Release.Service }}
{{- end }}

{{/* securityContext compatible Pod Security "restricted" */}}
{{- define "inventaire.containerSecurityContext" -}}
runAsNonRoot: true
allowPrivilegeEscalation: false
readOnlyRootFilesystem: true
capabilities:
  drop: ["ALL"]
seccompProfile:
  type: RuntimeDefault
{{- end }}
