# /*
#  * Copyright (c) 2021 Software AG, Darmstadt, Germany and/or its licensors
#  *
#  * SPDX-License-Identifier: Apache-2.0
#  *
#  *   Licensed under the Apache License, Version 2.0 (the "License");
#  *   you may not use this file except in compliance with the License.
#  *   You may obtain a copy of the License at
#  *
#  *       http://www.apache.org/licenses/LICENSE-2.0
#  *
#  *   Unless required by applicable law or agreed to in writing, software
#  *   distributed under the License is distributed on an "AS IS" BASIS,
#  *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  *   See the License for the specific language governing permissions and
#  *   limitations under the License.
#  *
#  */
{{/*
Expand the name of the chart.
*/}}
{{- define "apigateway.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "apigateway.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "apigateway.labels" -}}
helm.sh/chart: {{ include "apigateway.chart" . }}
app.kubernetes.io/name: {{ include "apigateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Custom prefix
*/}}
{{- define "apigateway.customPrefix" }}
{{- if .Values.global.customPrefix }}
{{- printf "%s-" .Values.global.customPrefix }}
{{- end }}
{{- end }}