FROM google/dart:2.12 AS build
COPY pubspec.yaml  /server/pubspec.yaml
WORKDIR /server
RUN dart pub get
COPY . .
RUN dart pub get --offline
RUN dart compile exe bin/server.dart -o bin/server

FROM subfuzion/dart:slim
COPY --from=build /server/bin/server /app/server
ENTRYPOINT [ "/app/server" ]