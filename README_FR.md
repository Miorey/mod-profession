# mod-profession

[English](README.md) | [Français](README_FR.md)

Modifications de Murloc Village sur les métiers : Calligraphie (glyphes de chevalier de la mort), Ingénierie (Mécabécane) et Enchantement (Poulet magique). Données uniquement (SQL), pas de scripts C++.

## Ce que fait le module

- **Monde :** les glyphes de chevalier de la mort sont retirés du jeu. Aucune des 33 recettes de glyphe de chevalier de la mort n'est enseignée par un maître ni ne peut être découverte.
- **Monde :** la Mécabécane et la Bécane de mekgénieur sont fabricables au niveau 60 avec des composants vanilla. Schémas : Ingénierie 300, 150 po, Exalté auprès de Gadgetzan pour la Mécabécane (Horde) et de Baie-du-Butin pour la Bécane de mekgénieur (Alliance), vendus par Jinky Twizzlefixxit (Mirage Raceway), qui vend aussi les pièces.
- **Monde :** la monture Oeuf de poulet magique est fabricable par les enchanteurs et peut être échangée. Formule : Enchantement 300, Exalté auprès du Cercle cénarien, 150 po, vendue par Kania (Fort cénarien). Composants : 1 Oeuf de poule et 50 de chaque poussière vanilla (étrange, d'âme, de vision, de rêve, d'illusion). Nécessite les données client correspondantes de [mvDBC](https://github.com/Miorey/mvDBC) (sort de fabrication 90000, formule 60006).
- **Personnages (exécuté une seule fois par base de personnages) :**
  - Les personnages qui ont appris des glyphes majeurs auprès d'un maître sont remboursés du prix du maître par courrier.
  - Toutes les recettes, tous les objets de glyphe (sacs, banque, courrier, banque de guilde, hôtel des ventes) et tous les glyphes appliqués de chevalier de la mort sont retirés. Chaque objet de glyphe ou glyphe appliqué est remboursé par courrier, au forfait de 10 po (`@refund_per_glyph`), et dans la banque de guilde pour les objets qui s'y trouvaient. Les enchères sont annulées : les enchérisseurs récupèrent leur enchère, les vendeurs leur dépôt.

## Installation

Placez le module dans `modules/mod-profession` et relancez CMake. AzerothCore applique `data/sql/` au démarrage du worldserver.

`src/` ne contient qu'un chargeur vide : AzerothCore n'applique le SQL d'un module que si celui-ci en a un.

## Crédits

* [Jackhein](https://github.com/Jackhein) (auteur du module)
* [Miorey](https://github.com/Miorey/)

Notre serveur : [Murloc Village](https://wotlk.murlocvillage.com/fr/). Merci à [AzerothCore](https://www.azerothcore.org/).
