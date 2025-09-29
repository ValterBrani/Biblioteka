# Biblioteka - Syst�me de Gestion de Biblioth�que

## Description du Projet

Biblioteka est un projet de base de donn�es SQL Server complet qui simule un syst�me de gestion de biblioth�que. L'initiative de ce projet est de fournir une base de donn�es qui couvre de nombreux aspects du d�veloppement SQL pour �tre en mesure de tester efficacement :

- **Projets SQL Server Database** (SQLPROJ)
- **Packages DACPAC** et leur d�ploiement
- **Comportements lors du d�ploiement sur un serveur de base de donn�es**

Ce projet sert comme environnement de test complet pour valider les fonctionnalit�s, performances et comportements de d�ploiement dans des sc�narios r�els.

## Architecture de la Base de Donn�es

### Tables Principales
- **Authors** : Gestion des auteurs avec informations biographiques
- **Books** : Catalogue des livres avec gestion des copies disponibles
- **Members** : Membres de la biblioth�que avec statut d'activit�
- **Borrowings** : Emprunts de livres avec dates et p�nalit�s
- **Returns** : Retours de livres avec calcul automatique des p�nalit�s
- **BookAuthors** : Relation many-to-many entre livres et auteurs
- **PenaltyPolicies** : Politiques de p�nalit�s configurables

### Vues
- **vw_ActivePenalties** : Vue des p�nalit�s actives
- **vw_OverdueBooks** : Livres en retard non retourn�s
- **vw_BorrowedBooksByMember** : Historique des emprunts par membre

### Proc�dures Stock�es
- **sp_BorrowBook** : Gestion compl�te de l'emprunt d'un livre
- **sp_ReturnBook** : Processus de retour avec calcul automatique des p�nalit�s

### Fonctions
- **fn_CalculatePenalty** : Calcul automatique des p�nalit�s bas� sur les politiques

### Triggers
- **tr_Borrowings_Insert** : D�cr�mente automatiquement les copies disponibles
- **tr_Borrowings_Update** : Incr�mente les copies lors des retours

### Index
- Index optimis�s pour les recherches fr�quentes (titres, noms, emprunts)
- Index filtr� pour les livres en retard et p�nalit�s actives

## Fonctionnalit�s Test�es

### Gestion des Transactions
- Transactions compl�tes dans les proc�dures stock�es
- Gestion d'erreurs avec ROLLBACK automatique
- Validation de l'int�grit� des donn�es

### Contraintes et Validation
- Contraintes de cl�s �trang�res
- Contraintes CHECK pour validation m�tier
- Contraintes UNIQUE pour �viter les doublons

### Automatisation
- Triggers pour mise � jour automatique des stocks
- Calculs automatiques de p�nalit�s
- Valeurs par d�faut intelligentes

### Performance
- Index strat�giques pour optimisation des requ�tes
- Index filtr� pour requ�tes sp�cialis�es
- Vues pour simplifier les requ�tes complexes

## Utilisation pour Tests

Ce projet est id�al pour tester :

1. **D�ploiement DACPAC** : Validation du processus de d�ploiement
2. **Migrations de sch�ma** : Test des changements de structure
3. **Performance des requ�tes** : Benchmark avec donn�es r�alistes
4. **Int�grit� referentielle** : Validation des contraintes
5. **Logique m�tier** : Test des proc�dures et fonctions
6. **Triggers et automatisation** : Validation des comportements automatiques

## Structure du Projet

## Installation et D�ploiement

1. Ouvrir le projet dans Visual Studio 2022
2. Construire le projet pour g�n�rer le DACPAC
3. D�ployer sur SQL Server via :
   - Visual Studio (Publish)
   - SqlPackage.exe
   - Azure Data Studio
   - SQL Server Management Studio

## Donn�es de Test

Le fichier `SeedData.sql` contient des donn�es d'exemple pour :
- Auteurs c�l�bres (George Orwell, J.K. Rowling, Victor Hugo)
- Livres populaires avec ISBN r�els
- Membres de test
- Politiques de p�nalit�s par d�faut

Ces donn�es permettent de tester imm�diatement toutes les fonctionnalit�s du syst�me.

---

**Biblioteka** - Un environnement complet pour ma�triser le d�veloppement et d�ploiement de bases de donn�es SQL Server.