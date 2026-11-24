-- Death Knight glyphs (Inscription): removed from the game.
-- The 33 Death Knight glyph recipes can no longer be learned: no trainer teaches them and none can be discovered.
-- Re-runnable.

-- Minor: Blood Tap 57209, Death's Embrace 57215, Horn of Winter 57217, Raise Dead 57228,
--        Corpse Explosion 57229, Pestilence 57230
-- Major: Anti-Magic Shell 57207, Heart Strike 57208, Bone Shield 57210, Chains of Ice 57211, Dark Command 57212,
--        Death Grip 57213, Death and Decay 57214, Frost Strike 57216, Icebound Fortitude 57218, Icy Touch 57219,
--        Obliterate 57220, Plague Strike 57221, the Ghoul 57222, Rune Strike 57223, Scourge Strike 57224,
--        Strangulate 57225, Unbreakable Armor 57226, Vampiric Blood 57227, Rune Tap 59338, Blood Strike 59339,
--        Death Strike 59340, Dark Death 64266, Disease 64267, Dancing Rune Weapon 64297, Hungering Cold 64298,
--        Unholy Blight 64299, Howling Blast 64300

-- No trainer teaches them (the major ones were taught by the Inscription trainers 119, 120 and 121)
DELETE FROM `trainer_spell`
WHERE `SpellId` IN (57207, 57208, 57209, 57210, 57211, 57212, 57213, 57214, 57215, 57216, 57217, 57218, 57219,
    57220, 57221, 57222, 57223, 57224, 57225, 57226, 57227, 57228, 57229, 57230, 59338, 59339, 59340, 64266, 64267,
    64297, 64298, 64299, 64300);

-- None can be discovered (Minor Inscription Research, Northrend Inscription Research, Book of Glyph Mastery).
-- Rows are deleted rather than set to chance 0, which AzerothCore reports as an error at every start.
DELETE FROM `skill_discovery_template`
WHERE `spellId` IN (57207, 57208, 57209, 57210, 57211, 57212, 57213, 57214, 57215, 57216, 57217, 57218, 57219,
    57220, 57221, 57222, 57223, 57224, 57225, 57226, 57227, 57228, 57229, 57230, 59338, 59339, 59340, 64266, 64267,
    64297, 64298, 64299, 64300);
