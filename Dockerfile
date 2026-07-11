# Build args are stamped by the shared pipeline (sebastiancardona-dev/workflows)
FROM alpine:3.20 AS build
ARG VERSION=dev
ARG GIT_SHA=unknown
ARG BUILD_TIME=unknown
COPY html /out
RUN printf '{"app":"hello-ecosystem","version":"%s","git_sha":"%s","build_time":"%s"}\n' \
      "$VERSION" "$GIT_SHA" "$BUILD_TIME" > /out/info.json

# Unprivileged variant: runs as uid 101, listens on 8080 — no root in the runtime image
FROM nginxinc/nginx-unprivileged:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /out /usr/share/nginx/html
