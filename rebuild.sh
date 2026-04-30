#!/bin/bash
set -e
echo "Suppression des images Docker obsolètes..."
docker image prune -a -f
echo "Rebuild complet de tous les services..."
docker compose build --no-cache
echo "Démarrage des services..."
docker compose up
