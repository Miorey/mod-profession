-- Death Knight glyphs (Inscription): one-time cleanup of existing characters.
-- Runs once per characters DB. Refunds the trainer price of the major glyphs
-- by mail, then removes the major and minor Death Knight glyph recipes.

-- Refund (trainer prices in copper, hardcoded: the world DB may not be reachable here)
SET @mail_id := (SELECT COALESCE(MAX(`id`), 0) FROM `mail`);
SET @now := UNIX_TIMESTAMP();

INSERT INTO `mail` (`id`, `messageType`, `stationery`, `sender`, `receiver`, `subject`, `body`,
    `expire_time`, `deliver_time`, `money`)
SELECT @mail_id + ROW_NUMBER() OVER (ORDER BY r.`guid`), 0, 41, 0, r.`guid`,
    'Remboursement / Refund',
    CONCAT('Suite à une analyse des finances de la guilde des Calligraphes, nous avons remarqué ',
        'qu''un certain nombre de glyphes enseignés n''étaient pas certifiés et avaient une valeur nulle. ',
        'Veuillez nous excuser pour la gêne occasionnée : vous trouverez ci-joint la somme trop perçue ',
        'par notre guilde lors de votre enseignement. Cordialement.\n\n',
        'After reviewing the finances of the Scribes'' guild, we found that some of the glyphs we taught ',
        'were not certified and had no value. We apologise for the inconvenience: please find enclosed ',
        'the amount our guild overcharged you. Kind regards.'),
    @now + 30 * 86400, @now, r.`money`
FROM (
    SELECT cs.`guid`, SUM(p.`money`) AS `money`
    FROM `character_spell` cs
    JOIN (
        SELECT 57210 AS `spell`, 9500 AS `money`
        UNION ALL SELECT 57213, 14250
        UNION ALL SELECT 57216, 9500
        UNION ALL SELECT 57219, 9500
        UNION ALL SELECT 57221, 20000
        UNION ALL SELECT 57222, 30000
        UNION ALL SELECT 57224, 30000
        UNION ALL SELECT 57225, 50000
        UNION ALL SELECT 57226, 20000
        UNION ALL SELECT 57227, 30000
        UNION ALL SELECT 59338, 20000
        UNION ALL SELECT 59339, 20000
        UNION ALL SELECT 59340, 30000
        UNION ALL SELECT 64266, 10000
        UNION ALL SELECT 64267, 10000
    ) p ON p.`spell` = cs.`spell`
    GROUP BY cs.`guid`
) r
WHERE r.`money` > 0;

-- Remove the major glyph recipes
DELETE FROM `character_spell`
WHERE `spell` IN (57210, 57213, 57216, 57219, 57221, 57222, 57224, 57225, 57226, 57227, 59338, 59339, 59340, 64266, 64267);

-- Remove the minor glyph recipes and Glyph of Death and Decay (no refund: learned by discovery)
DELETE FROM `character_spell`
WHERE `spell` IN (57209, 57214, 57215, 57217, 57228, 57229, 57230);
