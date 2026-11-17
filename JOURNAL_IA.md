# Journal IA — TP6 (Copilot)

Nom : Zaouga Hadil Dépôt : https://github.com/hadilzaouga1/rihla

Au moins 4 lignes, dont au moins une suggestion **modifiée** ou **rejetée**.

| # | Outil Copilot | Demande / intention | Décision | Pourquoi |
|---|---|---|---|---|
| 1 | Complétion | TODO basculer du FavorisModel | Modifiée | oubli de `notifyListeners()`, ajouté à la main |
| 2 | Chat inline (Ctrl+I) | « ajoute un badge avec le nombre de favoris » sur la NavigationDestination Favoris | Modifiée | Copilot proposait `context.watch` dans tout le `build` de HomeScreen, ce qui reconstruit tout l'écran à chaque favori ; j'ai utilisé `Consumer<FavorisModel>` autour du seul `Badge` et `isLabelVisible: nombre > 0` pour cacher le badge à 0 |
| 3 | /explain | Sélection de `context.watch<FavorisModel>().estFavori(destination)` et `context.read<FavorisModel>().gererFavori(destination)` | Acceptée | `watch` s'abonne au modèle et reconstruit le widget à chaque `notifyListeners()` ; `read` récupère le modèle une seule fois sans s'abonner, adapté à un callback comme onPressed |
| 4 |Complétion |estFavori(Destination d) dans le modèle | Rejetée| Copilot proposait _favoris.containsKey(d.nom) ; la clé doit être d.id (stable après rechargement API)|
| 5 |Message de commit (✨)  | proposer un message pour le commit du Provider|Modifiée |Copilot a proposé update main.dart ; corrigé au format feat(favoris): branche le ChangeNotifierProvider au-dessus de MaterialApp |

Outil : Complétion · Chat inline (Ctrl+I) · /explain · Message de commit (✨)
Décision : Acceptée · Modifiée · Rejetée

## /explain : watch et read (partie 2.4)
Ma reformulation, en une phrase :
watch pour afficher l’état à jour, read pour modifier l'état

## Questions de compréhension
**Partie 1** — Que se passe-t-il pour `main` si je casse l'application sur `feature/favoris` ?
`main` reste intact : les commits faits sur `feature/favoris` n'appartiennent qu'à cette branche. Tant que la branche n'est pas fusionnée par une Pull Request, la version validée sur `main` n'est pas affectée.
**Partie 2**
1. Pourquoi `FavoriteButton` peut-il être un `StatelessWidget` alors que son affichage change ?
FavoriteButton ne stocke pas lui-même l’état du favori : il le lit depuis FavorisModel avec context.watch. Quand ce modèle change, Provider reconstruit le widget, qui affiche alors le cœur plein ou vide.Il peut donc être StatelessWidget.

2. Pourquoi ranger les favoris par `id` plutôt que dans un `Set<Destination>` ?
Dans FavorisModel, les favoris sont indexés par d.id.Un Set<Destination> s’appuie sur l’égalité et le hashCode des objets. Comme Destination ne redéfinit pas ces méthodes, deux instances distinctes ayant le même id pourraient être considérées comme différentes.

3. Pourquoi les favoris disparaissent-ils après un hot restart ?
Les favoris sont conservés uniquement en mémoire dans la Map de FavorisModel. Un hot restart redémarre l’application et recrée le modèle avec une map vide.
Pour les conserver, il faut les enregistrer dans un stockage persistant
**Partie 4**
1. Pourquoi la Partie 3 n'a-t-elle produit aucun conflit ?
Parce que seule la branche `feature/favoris` avait modifié ces fichiers : `main` n'avait pas bougé depuis la création de la branche, donc Git a pu fusionner sans ambiguïté. Un conflit n'apparaît que si deux branches modifient la même ligne.

2. Que se passe-t-il si j'oublie de supprimer un marqueur `=======` ?
Le marqueur reste dans le fichier comme du texte : il n'est pas du code Dart valide, donc la compilation échoue (`flutter run` affiche une erreur de syntaxe), et même s'il passait, on commiterait un fichier contenant les deux versions.

