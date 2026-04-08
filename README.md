# Projet Kubernetes - Partie 1 : Horizontal Pod Autoscaler (HPA)

Ce projet démontre la mise en œuvre de l'autoscaling horizontal dans un cluster Kubernetes (Minikube). L'objectif est de faire varier automatiquement le nombre de pods d'une application en fonction de la charge CPU.

## 📂 Structure du Projet

* `app.py` : Application Flask avec un endpoint `/load` simulant un calcul intensif.
* `Dockerfile` : Image Docker basée sur Python Slim.
* `deployment.yaml` : Déploiement avec limites de ressources (100m CPU request).
* `service.yaml` : Service ClusterIP exposant le port 5000 sur le port 80.
* `hpa.yaml` : Configuration de l'autoscale (1 à 10 réplicas, seuil 70%).

---

## 🛠️ Étapes de mise en œuvre

### 1. Préparation de l'application (Python)

L'application utilise une boucle `while` pour consommer du CPU pendant 30 secondes à chaque appel de l'URL `/load`.

### 2. Création de l'image Docker

À la racine du projet, lancez :

```bash
docker build -t <votre-pseudo>/projet-hpa:latest .
docker push <votre-pseudo>/projet-hpa:latest
```

### 3. Configuration de l'environnement (Minikube)

Le HPA nécessite impérativement le Metrics Server pour fonctionner. Activez-le avec :

```Bash
minikube addons enable metrics-server
```

Vérifiez l'activation avec : `kubectl get pods -n kube-system`

### 4. Déploiement sur le Cluster

Appliquez les configurations YAML :

```Bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f hpa.yaml
```

### 🧪 Protocole de Test et Validation

#### Étape A : Surveillance du HPA

Ouvrez un terminal et surveillez l'état de l'autoscaler :

```Bash
kubectl get hpa flask-hpa --watch
```

Attendez de voir 0%/70% apparaître dans la colonne TARGETS.

#### Étape B : Simulation de charge

Ouvrez un second terminal et ouvrez le port de l'application :

```Bash
minikube service hpa-service --url
```

#### Étape C : Simulation de charge

Ouvrez un troisième terminal et lancez le générateur de trafic :

```Bash
curl http://127.0.0.1:XXXXX/load
```

On peut en lancer plusieurs pour simuler une charge plus importante.

#### Étape D : Observation du Scaling

Scale Up : Le CPU dépasse le seuil de 70%. Le nombre de pods passe de 1 à 3 (ou plus selon la charge).

Stabilisation : Le HPA maintient le nombre de pods nécessaire pour stabiliser la charge autour de 70%.

Scale Down : Arrêtez de surcharger le système. Après 5 secondes, le cluster réduit le nombre de pods de 1 (toutes les 5 secondes).
Scale Down : Arrêtez de surcharger le système. Après 5 secondes, le cluster réduit le nombre de pods de 1 (toutes les 5 secondes).

### 📊 Analyse des résultats

Le test confirme que le Horizontal Pod Autoscaler remplit son rôle :

* Détection automatique de la surcharge via le Metrics Server.

* Ajustement dynamique du nombre de réplicas pour garantir la performance.

* Optimisation des ressources en supprimant les pods inutiles après la charge.

### 🧹 Nettoyage

Pour supprimer les ressources créées :

```Bash
kubectl delete -f hpa.yaml,service.yaml,deployment.yaml
```
