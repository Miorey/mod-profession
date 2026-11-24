# mod-profession

[English](README.md) | [Français](README_FR.md)

Modifications de Murloc Village sur les métiers : Calligraphie (glyphes de chevalier de la mort) et Ingénierie (Mécabécane). Données uniquement (SQL), pas de scripts C++.

## Ce que fait le module

- **Monde :** les glyphes mineurs de chevalier de la mort et le Glyphe de Mort et décomposition ne peuvent plus être découverts. Les glyphes majeurs de chevalier de la mort ne sont enseignés que par les grands maîtres calligraphes du Norfendre.
- **Monde :** la Mécabécane et la Bécane de mekgénieur sont fabricables au niveau 60 avec des composants vanilla. Schémas : Ingénierie 300, Exalté auprès de Gadgetzan, 150 po, vendus par Jinky Twizzlefixxit (Mirage Raceway), qui vend aussi les pièces.
- **Personnages (exécuté une seule fois par base de personnages) :** les personnages qui ont appris les glyphes majeurs sont remboursés du prix du maître par courrier, et les recettes des glyphes majeurs et mineurs de chevalier de la mort sont retirées.

## Installation

Placez le module dans `modules/mod-profession` et relancez CMake. AzerothCore applique `data/sql/` au démarrage du worldserver.

`src/` ne contient qu'un chargeur vide : AzerothCore n'applique le SQL d'un module que si celui-ci en a un.

## Crédits

* [Jackhein](https://github.com/Jackhein) (auteur du module)
* [Miorey](https://github.com/Miorey/)

Notre serveur : [Murloc Village](https://wotlk.murlocvillage.com/fr/). Merci à [AzerothCore](https://www.azerothcore.org/).
