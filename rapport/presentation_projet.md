<div style="text-align: justify">
## 2. Presentation du projet

### 2. Description des travaux demandés

#### a- Objectif

L'objectif de ce projet est d'automatiser le pipline CI/CD de l'application web Django.

Le pipeline demandé admet l'architecture suivante :

```
  build -> Test -> scan -> push -> Deploy (Prod et Preprod) -> Test -> Monitor
```

#### b- Outils recommandés

Les outils recommandés pour ce projet sont les suivants:
- Jenkins
- docker
- docker-compose
- snyk
- Ansible
- Terraform
- ssh

Pour le docker-compose.yml file, on nous a demandé de s'inspirer du fichier suivant :

```yaml
version: '3.3'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    expose:
      - "8000"
    ports:
      - "8000:8000"
    links:
      - postgres
  postgres:
    image: postgres:9
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
```

#### c- build

Pour l'étape du build, on nous demande de produire un Dockerfile pour conteneuriser l'application. L'image  **python:3** est recommandée comme image de base.

#### d- Sécurité

On nous demande de bien tenir compte l'aspect sécurité  de ce projet et d'introduire les meilleures pratiques de sécurité lors de la mise en oeuvre des differents scripts.

### 2. Presentation de Django

Django est un framework de développement Web open source , écrit en Python. L'objectif fondamental de Django est de faciliter la création de sites Web complexes basés sur des bases de données.  Python est utilisé partout dans le framework, même pour les paramètres, les fichiers et les modèles de données. Django fournit également une interface administrative facultative de création, lecture, mise à jour et suppression qui est générée dynamiquement par introspection et configurée via des modèles d'administration. Certains sites bien connus utilisent Django; nous citons à titre d'exemple: Instagram ,  Mozilla , Disqus , Bitbucket....

Dans un site web traditionnel orienté-données, une application web attend une requête HTTP d'un navigateur web (ou tout autre client). Quand une requête est reçue, l'application en comprend les besoins d'après l'URL et parfois d'après les informations en POST data ou GET data. En fonction de ce qui est attendu, elle peut ensuite lire ou écrire l'information dans une base de données ou réaliser une autre tâche requise pour satisfaire la requête. L'application renvoie ensuite une réponse au navigateur web, créant souvent en dynamique une page HTML affichée dans le navigateur où les données récupérées sont insérées dans les balises d'un modèle HTML.

<div style="text-align: center">
<img src=./img/figures/django.png width="50000" height="400" ><br>[Fig. Structure du framework Django]
</div><br>

Les applications web Django regroupent généralement le code qui gère chacune de ces étapes dans des fichiers séparés :

***Vues (views.py)** : Une vue est une fonction de gestion des requêtes, qui reçoit des requêtes HTTP et renvoie des réponses HTTP. Les vues accèdent aux données requises pour satisfaire des requêtes via des modèles, et délèguent le formatage des réponses aux templates.

**Modèles (models.py)** : Les modèles sont des objets Python, qui définissent la structure des données d'une application, et fournissent des mécanismes de gestion (ajout, modification, suppression) et requêtent les enregistrements d'une base de données.

**Templates** : Un template est un fichier texte qui définit la structure ou la mise en page d'un fichier (comme une page HTML), avec des balises utilisées pour représenter le contenu. Une vue peut créer une page HTML en dynamique en utilisant un template HTML, en la peuplant avec les données d'un modèle. Un template peut-être utilisé pour définir la structure de n'importe quel type de fichier; il n'est pas obligatoire que ce dernier soit un HTML.

**URLs** :  Bien qu'il soit possible de traiter les requêtes de chaque URL via une fonction unique, il est bien plus viable d'écrire une fonction de vue isolée qui gèrera chaque ressource. Un mapper URL est utilisé pour rediriger les requêtes HTTP à la vue appropriée d'après l'URL de requête. Le mapper URL peut aussi faire la correspondance entre des patterns de chaînes de caractères ou de nombres qui apparaissent dans une URL et passer ces derniers comme données dans une fonction de vue.

### 2. Outils recommandées

#### 2.. Docker

Docker est un système d'exploitation pour conteneurs. Docker offre une méthode standard pour l'exécution du code.  De la même manière qu'une machine virtuelle virtualise le matériel serveur (c.-à-d. qu'il n'est plus nécessaire de le gérer directement), les conteneurs virtualisent le système d'exploitation d'un serveur. Docker est installé sur chaque serveur et  offre des commandes simples pour concevoir, démarrer ou arrêter des conteneurs.

Deux concepts centraux :

- Un conteneur : l’instance qui tourne sur la machine.  Un conteneur est une enveloppe virtuelle qui permet de distribuer une application avec tous les éléments dont elle a besoin pour fonctionner : fichiers source, environnement d'exécution, librairies, outils et fichiers. Ils sont assemblés en un ensemble cohérent et prêt à être déployé sur un serveur et son système d'exploitation (OS). Contrairement à la virtualisation de serveurs et à une machine virtuelle, le conteneur n’intègre pas de noyau, il s’appuie directement sur le noyau de l'ordinateur sur lequel il est déployé.

- Une image : un modèle pour créer un conteneur. Une image est un package qui inclut tout ce qui est nécessaire à l'exécution d'une application

Autres concepts primordiaux :

- Un volume : un espace virtuel pour gérer le stockage d’un conteneur et le partage entre conteneurs.
- Un registry : un serveur ou stocker des artefacts docker c’est à dire des images versionnées.
- Un orchestrateur : un outil qui gère automatiquement le cycle de vie des conteneurs (création/suppression).

#### 2.. Jenkins

<div style="text-align: center">
<img src=./img/figures/jenkins.png width="500" height="400" ><br>
[Fig. Les tâches de Jenkins]
</div><br>

Jenkins est un outil logiciel d’intégration continue. Il faut rappeler ici que l’intégration continue est une pratique de développement permettant aux développeurs d’apporter des changements à un code source dans un dossier partagé plusieurs fois par jour ou plus fréquemment. 

Jenkins est un logiciel open source, développé à l’aide du langage de programmation Java. Il permet de tester et de rapporter les changements effectués sur une large base de code en temps réel. En utilisant ce logiciel, les développeurs peuvent détecter et résoudre les problèmes dans une base de code rapidement. Ainsi les tests de nouveaux builds peuvent être automatisés, ce qui permet d’intégrer plus facilement des changements à un projet, de façon continue. L’objectif de Jenkin est en effet d’accélérer le développement de logiciels par le biais de l’automatisation. Jenkins permet l’intégration de toutes les étapes du cycle de développement. Il est basé sur un serveur qui s'exécute dans des conteneurs de servlets tels qu'Apache Tomcat . Il prend en charge les outils de contrôle de version , notamment AccuRev , CVS , Subversion , Git , Mercurial , Perforce , ClearCaseet RTC , et peut exécuter des projets basés sur Apache Ant , Apache Maven et sbt , ainsi que des scripts shell arbitraires et des commandes batch Windows .

#### 2.. Terraform

<div style="text-align: center">
<img src=./img/figures/terraform.png width="600" height="400" >
[Fig. Architecture de Terraform]
</div><br>

Terraform est un outil open source d'Infrastructure as Code (IaC) créé par HashiCorp. c'est un outil de codage déclaratif qui permet aux développeurs d'utiliser un langage de configuration appelé HCL (HashiCorp Configuration Language), qui décrit l'infrastructure cloud  pour l'exécution d'une application avec son "état final". 

Terraform a deux composants principaux qui composent son architecture:

- *Noyau Terraform* Terraform Core utilise deux sources d'entrée pour faire son travail. Dans un premier temps, la source d'entrée est une configuration Terraform qu'on configure en tant qu'utilisateur. Ici, on définit ce qui doit être créé ou provisionné. Et la seconde source d'entrée est le tfstat, dans lequel terraform maintient l'état à jour de la configuration actuelle de l'infrastructure.
Donc, ce que fait le noyau de terraform, c'est qu'il prend les entrées, et il élabore le plan de tout ce qui doit être réalisé. Il compare l'état actuel à la configuration desirée. Il détermine ce qui doit être fait pour atteindre cet état souhaité dans le fichier de configuration. Il indique ce qui doit être créé, ce qui doit être mis à jour, ce qui doit être supprimé pour créer et provisionner l'infrastructure.
- *Les fournisseurs* La, il peut s'agir de fournisseurs de cloud comme AWS, Azure ou d'autres infrastructures, en tant que plate-forme de services.

Terraform possède de nombreux avantages : il utilise une syntaxe simple, il peut mettre à disposition une infrastructure dans plusieurs clouds et centres de données sur site, et il peut remettre à disposition des infrastructures de façon sécurisée et efficace en réponse aux changements de configuration. Toutes ces qualités en font actuellement l'un des outils d'automatisation d'infrastructure les plus populaires.

#### 2.. Ansible

Ansible est une plate-forme logicielle libre pour la configuration et la gestion des ordinateurs. Elle combine le déploiement de logiciels (en) multi-nœuds, l'exécution des tâches ad-hoc, et la gestion de configuration. Elle gère les différents nœuds à travers SSH.  Le système utilise YAML pour exprimer des descriptions réutilisables de systèmes, appelées playbook.

<div style="text-align: center">
<img src=./img/figures/ansible.png width="600" height="400" >
 [Fig. Fonctionnement d'Ansible]
</div><br>

Ansible fonctionne en se connectant aux nœuds et en poussant des programmes appelés modules ansibles. Ansible exécute ensuite ces modules via SSH par défaut. Le nœud de gestion Ansible est le nœud de contrôle, qui contrôle toute l'exécution du Playbook. C'est le nœud à partir duquel on exécute l'installation. Le fichier d'inventaire fournit la liste des hôtes sur lequel les modules doivent être exécutés. Le nœud de gestion établit une connexion ssh, puis exécute les modules sur les machines hôtes et installe le produit. 

#### 2. Snyk

On pense souvent que les images et les conteneurs Docker sont sécurisés par défaut. Malheureusement, ce n'est pas le cas. De nombreux éléments affectent la sécurité des images Docker. Qu'il s'agisse de packages installés dans l'image, de bibliothèques utilisées par l'application ou même de l'image de base. Tous ces composants peuvent rendre  l'application vulnérable. Avec les problèmes liés à la sécurité, il est toujours préférable d'être proactif et d'essayer d'éviter les vulnérabilités avant qu'elles ne deviennent un problème réel. Le moyen le plus simple de déctercter des vulnérabilités dans l'image et de surveiller en permanence les problèmes de sécurité potentiels consiste à effectuer une inspection à l'aide d'outils tels que "Snyk".

Snyk est un outil qui peut aider à trouver des vulnérabilités connues dans les bibliothèques open source. Il peut identifier les packages vulnérables dans l'image via une base de données de vulnérabilités complète. Il peut également fournir un aperçu précis des vulnérabilités et surveiller les images.

</div>