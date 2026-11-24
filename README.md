# mod-profession

[English](README.md) | [Français](README_FR.md)

Murloc Village changes to professions: Inscription (Death Knight glyphs) and Engineering (Mechano-hog). Data only (SQL), no C++ scripts.

## What it does

- **World:** Death Knight glyphs are removed from the game. None of the 33 Death Knight glyph recipes is taught by a trainer or can be discovered.
- **World:** the Mechano-hog and Mekgineer's Chopper are craftable at level 60 with vanilla reagents. Schematics: Engineering 300, Exalted with Gadgetzan, 150 g, sold by Jinky Twizzlefixxit (Mirage Raceway), who also sells the vendor parts.
- **Characters (runs once per characters database):**
  - Characters who learned major glyphs from a trainer get the trainer price back by mail.
  - Every Death Knight glyph recipe, glyph item (bags, bank, mail, guild bank, auction house) and applied glyph is removed. Each glyph item or applied glyph is refunded by mail at a flat 10 gold (`@refund_per_glyph`), into the guild bank for guild bank items. Auctions are cancelled: bidders get their bid back, sellers their deposit.

## Install

Put the module in `modules/mod-profession` and re-run CMake. AzerothCore applies `data/sql/` at worldserver start.

`src/` only holds an empty loader: AzerothCore applies a module's SQL only when the module has one.

## Credits

* [Jackhein](https://github.com/Jackhein) (module author)
* [Miorey](https://github.com/Miorey/)

Our server: [Murloc Village](https://wotlk.murlocvillage.com/fr/). Thanks to [AzerothCore](https://www.azerothcore.org/).
