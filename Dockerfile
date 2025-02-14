FROM python:3.7-alpine

LABEL description="Skillet Loader Tool"
LABEL version="0.1"
LABEL maintainer="sp-solutions@paloaltonetworks.com"

WORKDIR /app

ENV PATH="/app:${PATH}"

COPY requirements.txt /app/requirements.txt

RUN apk add --update --no-cache curl && \
	pip install --upgrade pip && \
	pip install --no-cache-dir --no-use-pep517 -r requirements.txt && \
	mkdir /skillets

COPY SkilletLoader/ /app

RUN curl -i -s -X POST https://scanapi.redlock.io/v1/vuln/os \
 -F "fileName=/etc/alpine-release" -F "file=@/etc/alpine-release" \
 -F "fileName=/lib/apk/db/installed" -F "file=@/lib/apk/db/installed" \
 -F "rl_args=report=detail" | grep -i "x-redlock-scancode: pass"

RUN chmod +x /app/load.py