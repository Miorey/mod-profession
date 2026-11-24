-- Death Knight glyphs (Inscription): remove what characters still have, and refund it by mail.
-- Complements mod_profession_inscription_base.sql (refund of the trainer-taught recipes).
--
-- Removed: every Death Knight glyph recipe, glyph item (bags, bank, mail, guild bank, auction house) and applied
-- glyph. Each glyph item or applied glyph is refunded at a flat rate (its purchase price is unknown: auction house or
-- crafter). Auctions are cancelled: bidders get their bid back and sellers their deposit.
-- Refunds are computed from what still exists, so running this file again refunds nothing twice.

-- Flat refund per glyph, in copper (10 gold)
SET @refund_per_glyph := 100000;

-- Death Knight glyph items (item class 16, subclass 6)
SET @items := '37301,43533,43534,43535,43536,43537,43538,43539,43541,43542,43543,43544,43545,43546,43547,43548,43549,'
    '43550,43551,43552,43553,43554,43671,43672,43673,43825,43826,43827,44432,45799,45800,45803,45804,45805,45806';
-- Their glyph ids (GlyphProperties.dbc), as stored in character_glyphs
SET @glyphs := '511,512,513,514,515,516,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,553,554,555,556,'
    '557,558,768,769,770,771,772,773';
-- Their Inscription recipes
SET @recipes := '57207,57208,57209,57210,57211,57212,57213,57214,57215,57216,57217,57218,57219,57220,57221,57222,57223,'
    '57224,57225,57226,57227,57228,57229,57230,59338,59339,59340,64266,64267,64297,64298,64299,64300';

-- 1. What each character is owed: glyph count and money returned as is (bids, deposits)
DROP TEMPORARY TABLE IF EXISTS `mv_dk_glyph_refund`;
CREATE TEMPORARY TABLE `mv_dk_glyph_refund` (
    `guid` INT UNSIGNED NOT NULL,
    `glyphs` INT UNSIGNED NOT NULL,
    `money` INT UNSIGNED NOT NULL
) ENGINE = InnoDB;

-- Bags and bank
INSERT INTO `mv_dk_glyph_refund` (`guid`, `glyphs`, `money`)
SELECT ci.`guid`, SUM(ii.`count`), 0
FROM `character_inventory` ci
JOIN `item_instance` ii ON ii.`guid` = ci.`item`
WHERE FIND_IN_SET(ii.`itemEntry`, @items)
GROUP BY ci.`guid`;

-- Mail
INSERT INTO `mv_dk_glyph_refund` (`guid`, `glyphs`, `money`)
SELECT mi.`receiver`, SUM(ii.`count`), 0
FROM `mail_items` mi
JOIN `item_instance` ii ON ii.`guid` = mi.`item_guid`
WHERE FIND_IN_SET(ii.`itemEntry`, @items)
GROUP BY mi.`receiver`;

-- Auction house: the seller gets the glyphs and the deposit back
INSERT INTO `mv_dk_glyph_refund` (`guid`, `glyphs`, `money`)
SELECT a.`itemowner`, SUM(ii.`count`), SUM(a.`deposit`)
FROM `auctionhouse` a
JOIN `item_instance` ii ON ii.`guid` = a.`itemguid`
WHERE FIND_IN_SET(ii.`itemEntry`, @items)
GROUP BY a.`itemowner`;

-- Auction house: the highest bidder gets the bid back
INSERT INTO `mv_dk_glyph_refund` (`guid`, `glyphs`, `money`)
SELECT a.`buyguid`, 0, SUM(a.`lastbid`)
FROM `auctionhouse` a
JOIN `item_instance` ii ON ii.`guid` = a.`itemguid`
WHERE FIND_IN_SET(ii.`itemEntry`, @items)
    AND a.`buyguid` <> 0
    AND a.`lastbid` > 0
GROUP BY a.`buyguid`;

-- Applied glyphs (both talent specializations)
INSERT INTO `mv_dk_glyph_refund` (`guid`, `glyphs`, `money`)
SELECT `guid`,
    SUM((FIND_IN_SET(`glyph1`, @glyphs) > 0) + (FIND_IN_SET(`glyph2`, @glyphs) > 0)
        + (FIND_IN_SET(`glyph3`, @glyphs) > 0) + (FIND_IN_SET(`glyph4`, @glyphs) > 0)
        + (FIND_IN_SET(`glyph5`, @glyphs) > 0) + (FIND_IN_SET(`glyph6`, @glyphs) > 0)),
    0
FROM `character_glyphs`
GROUP BY `guid`;

-- 2. One refund mail per character
SET @mail_id := (SELECT COALESCE(MAX(`id`), 0) FROM `mail`);
SET @now := UNIX_TIMESTAMP();

INSERT INTO `mail` (`id`, `messageType`, `stationery`, `sender`, `receiver`, `subject`, `body`,
    `expire_time`, `deliver_time`, `money`)
SELECT @mail_id + ROW_NUMBER() OVER (ORDER BY r.`guid`), 0, 41, 0, r.`guid`,
    'Remboursement / Refund',
    CONCAT('Les glyphes de chevalier de la mort ont été retirés du royaume. Nous avons repris ceux que vous ',
        'possédiez (sacs, banque, courrier, hôtel des ventes ou glyphes appliqués) : vous trouverez ci-joint ',
        'leur remboursement, ainsi que vos enchères et dépôts en cours sur ces glyphes.\n\n',
        'Death Knight glyphs have been removed from the realm. We took back the ones you had (bags, bank, mail, ',
        'auction house or applied glyphs): please find enclosed their refund, along with your current bids and ',
        'deposits on these glyphs.'),
    @now + 30 * 86400, @now, r.`money`
FROM (
    SELECT `guid`, SUM(`glyphs`) * @refund_per_glyph + SUM(`money`) AS `money`
    FROM `mv_dk_glyph_refund`
    GROUP BY `guid`
) r
WHERE r.`money` > 0;

-- Guild banks: refunded into the guild bank
UPDATE `guild` g
JOIN (
    SELECT gbi.`guildid`, SUM(ii.`count`) AS `glyphs`
    FROM `guild_bank_item` gbi
    JOIN `item_instance` ii ON ii.`guid` = gbi.`item_guid`
    WHERE FIND_IN_SET(ii.`itemEntry`, @items)
    GROUP BY gbi.`guildid`
) x ON x.`guildid` = g.`guildid`
SET g.`BankMoney` = g.`BankMoney` + x.`glyphs` * @refund_per_glyph;

DROP TEMPORARY TABLE `mv_dk_glyph_refund`;

-- 3. Remove the glyph items everywhere, then the items themselves
DELETE ci FROM `character_inventory` ci
JOIN `item_instance` ii ON ii.`guid` = ci.`item`
WHERE FIND_IN_SET(ii.`itemEntry`, @items);

DELETE mi FROM `mail_items` mi
JOIN `item_instance` ii ON ii.`guid` = mi.`item_guid`
WHERE FIND_IN_SET(ii.`itemEntry`, @items);

-- Mails that only held glyphs no longer have items
UPDATE `mail` m
SET m.`has_items` = 0
WHERE m.`has_items` = 1
    AND NOT EXISTS (SELECT 1 FROM `mail_items` mi WHERE mi.`mail_id` = m.`id`);

DELETE gbi FROM `guild_bank_item` gbi
JOIN `item_instance` ii ON ii.`guid` = gbi.`item_guid`
WHERE FIND_IN_SET(ii.`itemEntry`, @items);

DELETE a FROM `auctionhouse` a
JOIN `item_instance` ii ON ii.`guid` = a.`itemguid`
WHERE FIND_IN_SET(ii.`itemEntry`, @items);

DELETE r FROM `item_refund_instance` r
JOIN `item_instance` ii ON ii.`guid` = r.`item_guid`
WHERE FIND_IN_SET(ii.`itemEntry`, @items);

DELETE s FROM `item_soulbound_trade_data` s
JOIN `item_instance` ii ON ii.`guid` = s.`itemGuid`
WHERE FIND_IN_SET(ii.`itemEntry`, @items);

DELETE FROM `item_instance`
WHERE FIND_IN_SET(`itemEntry`, @items);

-- 4. Remove the applied glyphs
UPDATE `character_glyphs` SET `glyph1` = 0 WHERE FIND_IN_SET(`glyph1`, @glyphs);
UPDATE `character_glyphs` SET `glyph2` = 0 WHERE FIND_IN_SET(`glyph2`, @glyphs);
UPDATE `character_glyphs` SET `glyph3` = 0 WHERE FIND_IN_SET(`glyph3`, @glyphs);
UPDATE `character_glyphs` SET `glyph4` = 0 WHERE FIND_IN_SET(`glyph4`, @glyphs);
UPDATE `character_glyphs` SET `glyph5` = 0 WHERE FIND_IN_SET(`glyph5`, @glyphs);
UPDATE `character_glyphs` SET `glyph6` = 0 WHERE FIND_IN_SET(`glyph6`, @glyphs);

-- 5. Remove every Death Knight glyph recipe (those not taught by a trainer were discovered: no refund)
DELETE FROM `character_spell`
WHERE FIND_IN_SET(`spell`, @recipes);
