# Journal IA — TP6 (Copilot)

Nom : Zaouga Hadil Dépôt : https://github.com/hadilzaouga1/rihla

Au moins 4 lignes, dont au moins une suggestion **modifiée** ou **rejetée**.

| # | Outil Copilot | Demande / intention | Décision | Pourquoi |
|---|---|---|---|---|
| 1 | Complétion | TODO basculer du FavorisModel | Modifiée | oubli de `notifyListeners()`, ajouté à la main |
| 2 |Chat inline (Ctrl+I) | ajoute un badge avec le nombre de favoris dans la BottomNavigationBar|la suggestion utilisait `context.watch` dans le `BottomNavigationBarItem` sans `Consumer`, provoquait un rebuild de toute la barre ; remplacé par `Consumer<FavorisModel>` ciblé | 
| 3 | /explain|/explain final favori = context.watch<FavorisModel>().estFavori(destination); context.read<FavorisModel>().basculer(destination); | context.read<FavorisModel>() récupère le modèle sans s’abonner aux changements;basculer(destination) ajoute la destination aux favoris si elle n’y est pas, ou la retire si elle y est déjà. C’est utilisé au clic, car on veut déclencher l’action, pas écouter depuis le callback. |
| 4 |Complétion |estFavori(Destination d) dans le modèle | Rejetée| Copilot proposait _favoris.containsKey(d.nom) ; la clé doit être d.id (stable après rechargement API)|
| 5 |Message de commit (✨)  | proposer un message pour le commit du Provider|Modifiée |Copilot a proposé update main.dart ; corrigé au format feat(favoris): branche le ChangeNotifierProvider au-dessus de MaterialApp |

Outil : Complétion · Chat inline (Ctrl+I) · /explain · Message de commit (✨)
Décision : Acceptée · Modifiée · Rejetée

## /explain : watch et read (partie 2.4)
Ma reformulation, en une phrase :
watch pour afficher l’état à jour, read pour modifier l'état

## Questions de compréhension
**Partie 1** — Que se passe-t-il pour `main` si je casse l'application sur `feature/favoris` ?
main reste intact : les modifications et commits faits sur feature/favoris appartiennent à cette branche. Si l’application y est cassée, le problème n’affecte pas la version validée sur main tant que tu ne fusionnes pas la branche.
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
La Partie 3 n’a probablement pas produit de conflit parce que Git pouvait combiner automatiquement les changements : les branches n’avaient pas modifié les mêmes lignes de façon incompatible, ou l’une était déjà à jour avec les changements de l’autre.

2. Que se passe-t-il si j'oublie de supprimer un marqueur `=======` ?
Le marqueur sépare les deux versions d’un conflit. S’il reste dans le fichier, le conflit n’est pas vraiment résolu : le marqueur est traité comme du texte du fichier et peut provoquer une erreur de compilation ou un comportement incorrect.

