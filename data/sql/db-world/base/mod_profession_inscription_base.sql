-- Death Knight glyphs (Inscription)

-- Minor glyphs and Glyph of Death and Decay can no longer be discovered:
-- Blood Tap 57209, Death and Decay 57214, Death's Embrace 57215, Horn of Winter 57217,
-- Raise Dead 57228, Corpse Explosion 57229, Pestilence 57230
UPDATE `skill_discovery_template` SET `chance` = 0
WHERE `spellId` IN (57209, 57214, 57215, 57217, 57228, 57229, 57230);

-- Major glyphs are taught only by the Northrend Grand Master trainers (trainer 119):
-- remove them from the Master (120) and basic (121) inscription trainers.
-- Bone Shield 57210, Death Grip 57213, Frost Strike 57216, Icy Touch 57219, Plague Strike 57221,
-- Ghoul 57222, Scourge Strike 57224, Strangulate 57225, Unbreakable Armor 57226, Vampiric Blood 57227,
-- Rune Tap 59338, Blood Strike 59339, Death Strike 59340, Dark Death 64266, Disease 64267
DELETE FROM `trainer_spell`
WHERE `TrainerId` IN (120, 121)
    AND `SpellId` IN (57210, 57213, 57216, 57219, 57221, 57222, 57224, 57225, 57226, 57227,
        59338, 59339, 59340, 64266, 64267);
