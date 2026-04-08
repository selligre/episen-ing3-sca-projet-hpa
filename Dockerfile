# Utilisation d'une image légère de Python
FROM python:3.9-slim

# Définition du répertoire de travail dans le container
WORKDIR /app

# Copie du fichier des dépendances (si tu en as un) ou installation directe
# Ici on installe Flask directement pour faire simple
RUN pip install --no-cache-dir flask

# Copie du code de l'application dans le container
COPY app.py .

# Exposition du port sur lequel Flask écoute
EXPOSE 5000

# Commande pour démarrer l'application
CMD ["python", "app.py"]