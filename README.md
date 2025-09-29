# Biblioteka - Système de Gestion de Bibliothèque

## Description du Projet

Biblioteka est un projet de base de données SQL Server complet qui simule un système de gestion de bibliothèque. L'initiative de ce projet est de fournir une base de données qui couvre de nombreux aspects du développement SQL pour être en mesure de tester efficacement :

- **Projets SQL Server Database** (SQLPROJ)
- **Packages DACPAC** et leur déploiement
- **Comportements lors du déploiement sur un serveur de base de données**

Ce projet sert comme environnement de test complet pour valider les fonctionnalités, performances et comportements de déploiement dans des scénarios réels.

## Architecture de la Base de Données

### Tables Principales
- **Authors** : Gestion des auteurs avec informations biographiques
- **Books** : Catalogue des livres avec gestion des copies disponibles
- **Members** : Membres de la bibliothèque avec statut d'activité
- **Borrowings** : Emprunts de livres avec dates et pénalités
- **Returns** : Retours de livres avec calcul automatique des pénalités
- **BookAuthors** : Relation many-to-many entre livres et auteurs
- **PenaltyPolicies** : Politiques de pénalités configurables

### Vues
- **vw_ActivePenalties** : Vue des pénalités actives
- **vw_OverdueBooks** : Livres en retard non retournés
- **vw_BorrowedBooksByMember** : Historique des emprunts par membre

### Procédures Stockées
- **sp_BorrowBook** : Gestion complète de l'emprunt d'un livre
- **sp_ReturnBook** : Processus de retour avec calcul automatique des pénalités

### Fonctions
- **fn_CalculatePenalty** : Calcul automatique des pénalités basé sur les politiques

### Triggers
- **tr_Borrowings_Insert** : Décrémente automatiquement les copies disponibles
- **tr_Borrowings_Update** : Incrémente les copies lors des retours

### Index
- Index optimisés pour les recherches fréquentes (titres, noms, emprunts)
- Index filtré pour les livres en retard et pénalités actives

## Fonctionnalités Testées

### Gestion des Transactions
- Transactions complètes dans les procédures stockées
- Gestion d'erreurs avec ROLLBACK automatique
- Validation de l'intégrité des données

### Contraintes et Validation
- Contraintes de clés étrangères
- Contraintes CHECK pour validation métier
- Contraintes UNIQUE pour éviter les doublons

### Automatisation
- Triggers pour mise à jour automatique des stocks
- Calculs automatiques de pénalités
- Valeurs par défaut intelligentes

### Performance
- Index stratégiques pour optimisation des requêtes
- Index filtré pour requêtes spécialisées
- Vues pour simplifier les requêtes complexes

## Utilisation pour Tests

Ce projet est idéal pour tester :

1. **Déploiement DACPAC** : Validation du processus de déploiement
2. **Migrations de schéma** : Test des changements de structure
3. **Performance des requêtes** : Benchmark avec données réalistes
4. **Intégrité referentielle** : Validation des contraintes
5. **Logique métier** : Test des procédures et fonctions
6. **Triggers et automatisation** : Validation des comportements automatiques

## Structure du Projet

## Installation et Déploiement

1. Ouvrir le projet dans Visual Studio 2022
2. Construire le projet pour générer le DACPAC
3. Déployer sur SQL Server via :
   - Visual Studio (Publish)
   - SqlPackage.exe
   - Azure Data Studio
   - SQL Server Management Studio

## Données de Test

Le fichier `SeedData.sql` contient des données d'exemple pour :
- Auteurs célèbres (George Orwell, J.K. Rowling, Victor Hugo)
- Livres populaires avec ISBN réels
- Membres de test
- Politiques de pénalités par défaut

Ces données permettent de tester immédiatement toutes les fonctionnalités du système.

---

**Biblioteka** - Un environnement complet pour maîtriser le développement et déploiement de bases de données SQL Server.