CREATE TABLE IF NOT EXISTS `g_welcome_rewards` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(80) NOT NULL,
    `claimed_items` TINYINT(1) NOT NULL DEFAULT 0,
    `claimed_vehicle` TINYINT(1) NOT NULL DEFAULT 0,
    `claimed_items_at` TIMESTAMP NULL DEFAULT NULL,
    `claimed_vehicle_at` TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `identifier` (`identifier`)
);