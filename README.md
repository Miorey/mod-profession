# mod-profession

[English](README.md) | [Français](README_FR.md)

Murloc Village changes to Inscription for the Death Knight glyphs. Data only (SQL), no C++ scripts.

## What it does

- **World:** the minor Death Knight glyphs and Glyph of Death and Decay can no longer be discovered. The major Death Knight glyphs are taught only by the Northrend Grand Master Inscription trainers.
- **Characters (runs once per characters database):** characters who learned the major glyphs get the trainer price back by mail, and the major and minor Death Knight glyph recipes are removed.

## Install

Put the module in `modules/mod-profession` and re-run CMake. AzerothCore applies `data/sql/` at worldserver start.

`src/` only holds an empty loader: AzerothCore applies a module's SQL only when the module has one.

## Credits

* [Jackhein](https://github.com/Jackhein) (module author)
* [Miorey](https://github.com/Miorey/)

Our server: [Murloc Village](https://wotlk.murlocvillage.com/fr/). Thanks to [AzerothCore](https://www.azerothcore.org/).
