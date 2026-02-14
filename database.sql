CREATE SCHEMA `shop` ;
CREATE SCHEMA `accounts`;

CREATE TABLE `accounts`.`users` (
  `id` VARCHAR(36) PRIMARY KEY NOT NULL DEFAULT (UUID()),
  `ms_uuid` VARCHAR(36) NOT NULL,
  UNIQUE INDEX `idusers_UNIQUE` (`id` ASC) VISIBLE
);

CREATE TABLE `shop`.`categories` (
  `id` VARCHAR(36) PRIMARY KEY NOT NULL DEFAULT (UUID()),
  `name` VARCHAR(100) NOT NULL,
  `slug` VARCHAR(100) NOT NULL,
  UNIQUE INDEX `idcategories_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
  UNIQUE INDEX `slug_UNIQUE` (`slug` ASC) VISIBLE
);

CREATE TABLE `shop`.`products` (
  `id` VARCHAR(36) PRIMARY KEY NOT NULL DEFAULT (UUID()),
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT(200) NOT NULL,
  `price` INT NOT NULL,
  `stock` INT NOT NULL,
  `category` VARCHAR(36) NULL,
  `type` ENUM('physical', 'digital') NOT NULL DEFAULT 'digital',
  `metadata` JSON,
  `created_at` DATETIME DEFAULT (NOW()),
  UNIQUE INDEX `idproducts_UNIQUE` (`id` ASC) VISIBLE
);

CREATE TABLE `shop`.`product_images` (
  `id` VARCHAR(36) PRIMARY KEY NOT NULL DEFAULT (UUID()),
  `product` VARCHAR(36) REFERENCES products(id) ON DELETE CASCADE,
  `url` TEXT NOT NULL,
  `is_main` TINYINT NOT NULL,
  `position` INT GENERATED ALWAYS AS (0) VIRTUAL,
  UNIQUE INDEX `idproductimage_UNIQUE` (`id` ASC) VISIBLE
);

CREATE TABLE `shop`.`orders` (
  `id` VARCHAR(36) PRIMARY KEY NOT NULL DEFAULT (UUID()),
  `user` VARCHAR(36) REFERENCES accounts.users(id),
  `total` INT NOT NULL,
  `status` ENUM('pending', 'paid', 'shipped', 'cancelled', 'refunded') NOT NULL DEFAULT 'pending',
  `created_at` DATETIME DEFAULT (NOW()),
  UNIQUE INDEX `idorders_UNIQUE` (`id` ASC) VISIBLE
);

CREATE TABLE `shop`.`order_items` (
  `id` VARCHAR(36) PRIMARY KEY NOT NULL DEFAULT (UUID()),
  `order` VARCHAR(36) REFERENCES orders(id) ON DELETE CASCADE,
  `product` VARCHAR(36) REFERENCES products(id),
  `product_name` VARCHAR(255) NOT NULL,
  `product_price` INT NOT NULL,
  `quantity` INT NOT NULL,
  UNIQUE INDEX `idordersitems_UNIQUE` (`id` ASC) VISIBLE
);

CREATE TABLE `shop`.`payments` (
    `id` VARCHAR(36) PRIMARY KEY NOT NULL DEFAULT (UUID()),
    `order` VARCHAR(36) REFERENCES orders(id) ON DELETE CASCADE,
    `stripe_payment_intent_id` VARCHAR(255) NOT NULL,
    `amount` INT NOT NULL,
    `created_at` DATETIME DEFAULT (NOW()),
  UNIQUE INDEX `idpayments_UNIQUE` (`id` ASC) VISIBLE
);

CREATE TABLE `shop`.`discounts` (
  `id` VARCHAR(36) PRIMARY KEY NOT NULL DEFAULT (UUID()),
  `discount_type` ENUM('percentage', 'fixed') NOT NULL DEFAULT 'percentage',
  `discount_value` INT NOT NULL,
  `max_discount_amount` INT,
  `metadata` JSON,
  `min_order_amount` INT NOT NULL DEFAULT 0,
  `max_uses` INT,
  `max_uses_per_user` INT DEFAULT 1,
  `uses` INT NOT NULL DEFAULT 0,
  `start_at` DATETIME NOT NULL DEFAULT (NOW()),
  `expires_at` DATETIME,
  `created_at` DATETIME DEFAULT (NOW()),
  UNIQUE INDEX `iddiscounts_UNIQUE` (`id` ASC) VISIBLE
);

CREATE TABLE `shop`.`discount_history` (
  `id` VARCHAR(36) PRIMARY KEY NOT NULL DEFAULT (UUID()),
  `discount_id` VARCHAR(36) REFERENCES discounts(id),
  `user_id` VARCHAR(36) REFERENCES accounts.users(id),
  `order_id` VARCHAR(36) REFERENCES orders(id),
  `used_at` DATETIME DEFAULT (NOW()),
  UNIQUE INDEX `iddiscountshistory_UNIQUE` (`id` ASC) VISIBLE
);
