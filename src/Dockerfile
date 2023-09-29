ARG BASE_IMAGE_TAG=3.11.5-alpine
ARG BASE_IMAGE=python

FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG} as builder
RUN apk update && apk add musl-dev libpq-dev gcc

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# upgrade pip
RUN pip install --upgrade pip

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade -r requirements.txt

##
FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG} as final
LABEL maintainer="Admir Trakic <atrakic@users.noreply.github.com>"

RUN addgroup --system fastapi \
    && adduser --system --ingroup fastapi fastapi

COPY --chown=fastapi:fastapi --from=builder /opt/venv /opt/venv

ENV PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1 \
  PATH="/opt/venv/bin:$PATH"

WORKDIR /app
COPY --chown=fastapi:fastapi . ./
USER fastapi

EXPOSE 3000
CMD ["uvicorn", "main:app", "--proxy-headers", "--host", "0.0.0.0", "--port", "3000"]
