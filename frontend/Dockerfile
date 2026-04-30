# Build Flutter Web
FROM ghcr.io/cirruslabs/flutter:3.22.0 AS build

WORKDIR /app

# Optimisation cache (important 🔥)
COPY pubspec.* ./
RUN flutter pub get

# Copy reste du code
COPY . .

RUN flutter build web --release

# Serve with nginx
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]