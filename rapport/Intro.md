# Introduction

<div style="text-align: justify">

Dans le monde de l'IT ("Information Technology"), il existe deux grands corps de métiers : les développeurs logiciels (Dev) et les administrateurs de systèmes et d'architectures (Ops). Les objectifs de ces deux fonctions peuvent paraitrent antagonistes. En effet, les Dev ont pour mission de créer, d'optimiser et de faire évoluer rapidement des applications en fonction des dernières technologies. Les Ops, quant à eux, peuvent être réticents aux changements car ils doivent assurer la mise en production de l'application en garantissant sa disponibilité et son temps de réponse. Historiquement, ces deux équipes, tout en travaillant sur un projet commun, effectuaient leurs tâches séparemment et communiquaient très peu (culture de silo). L'isolement de ces deux équipes pouvaient donc entrainer des conflits qui ont menés à la création d'un "mur de la confusion" séparant l'équipe Dev souhaitant de rapide mise à jour de l'application et l'équipe Ops jugeant par la stabilité de cette application.
De plus, l'arrivée des méthodes Agile (comme Scrum), préconisant plutôt la fixation d’objectifs à court terme par la réalisation de courts cycles de développement (itérations), ont considérablement raccourci les délais dans la mise à jour des applications pour la correction d'erreur ou l'ajout de nouvelles fonctionnalités. De plus, l'essor important de ces méthodes Agiles peut s'expliquer par l'amélioration, entre autres, du délai entre le développement d’une application et sa disponibilité pour les utilisateurs (time-to-market). Pour ces raisons, les entreprises du secteur informatique ont dû changer de mode de fonctionnement et la culture DevOps a pu apparaitre.
</div>

## Qu'est-ce que le DevOps ?

<div style="text-align: justify">

Pour commencer, le terme DevOps a été créé en 2007 par Patrick Debois pour créer une culture visant à rassembler les équipes Dev et Ops. Cette combinaison de <bold>philosophies</bold> de travail a pour principal objectif de permettre la livraison d'applications (ou de fonctionnalités / services) dans des délais optimisés tout en améliorant la qualité et la fiabilité de ces applications. Pour cela, le DevOps doit permettre l'amélioration de la collaboration entre les équipes Dev et Ops tout en utilisant différentes technologies pour automatiser l'intégralité du processus de conception d'une application.

Ainsi, le DevOps va particulièrement contribuer à l'automatisation et à l'amélioration du CI/CD qui constituent les deux grandes phases du cycle de conception d'une application :

* CI ("Continuous Integration") : correction, amélioration et tests du code de l'application en continu
* CD ("Continuous Deployment") : déploiement et mise en exploitation continu des nouvelles versions de l'application

En effet, la culture DevOps intervient lors de toutes les phases du cycle de conception d'une application assurés pes les équipes Dev et Ops :

* "Continuous Integration" par l'équipe Dev :
  * "Plan" : identification du besoin et des exigences
  * "Code" : écriture du code et conception de l'application
  * "Build" : création du "package" du code de l'application
  * "Test" : réalisation de tests sur l'application
* "Continuous Deployment" par l'équipe Ops :
  * "Release" : adaptation de l'application pour son déploiement
  * "Deploy" : déploiement de l'application sur différents serveurs (environnements)
  * "Operate" : mise en exploitation de l'application
  * "Monitor" : supervision de l'application et de sa disponibilité

</div>

![Cycle DevOps](./img/schema-devops.png)<div style="text-align: center">Cycle de conception d'une application</div>

<div style="text-align: justify">
En plus des différentes technologies utilisées pour assurer toutes ces étapes du cycle de conception d'une application, le DevOps se repose sur cinq piliers illustrés par le sigle C.A.L.M.S. :

* **C**ulture : partage d'une culture commune par toutes les personnes de l'entreprise
* **A**utomatisation : automatisation des processus pour faciliter les tâches des équipes Dev et Ops
* **L**ean : application de la méthodologie LEAN pour améliorer l'organisation et l'efficacité des équipes
* **M**esure : évaluation de l'avancement des tâches et de différents indicateurs pour augmenter l'efficacité
* **S**olidarité : amélioration du travail en équipe

</div>

## Contexte du projet et organisation

<div style="text-align: justify">

Le projet décrit dans ce rapport est un projet de fin de formation réalisée avec l'institut de formation AJC. Dans le cadre d'une POEI avec la société Umanis, cette formation "Consultant DevOps" de trois mois a pour objectif principal de comprendre les enjeux de la méthodologie DevOps par l'administration et l'exploitation d'infrastructures Linux, l'utilisation de ressources du cloud AWS et la mise en oeuvre d'une plateforme d’intégration continue.

Ce projet a été réalisé par Lilya Ait Mokhtar, Christophe Leviantis, Alain Mariathas, Yamen Othmani et Michael Cholay. Étant un projet pédagogique et pour respecter les valeurs DevOps de culture, de solidarité et de partage de connaissance, toutes les taches ont été effectuées avec l'intégralité du groupe.

</div>