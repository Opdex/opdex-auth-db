DROP EVENT IF EXISTS RemoveExpiredAuthSuccessEvent;
DROP TABLE IF EXISTS token_log;
DROP TABLE IF EXISTS auth_success;

CREATE TABLE IF NOT EXISTS auth_success(
    Id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    Audience VARCHAR(255) NOT NULL,
    Address VARCHAR(50) NOT NULL,
    Expiry DATETIME NOT NULL,
    PRIMARY KEY (Id),
    CONSTRAINT auth_success_address_uq UNIQUE (Address)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS token_log(
    RefreshToken VARCHAR(24) NOT NULL,
    AuthSuccessId BIGINT UNSIGNED NOT NULL,
    CreatedAt DATETIME NOT NULL,
    PRIMARY KEY (RefreshToken),
    CONSTRAINT token_log_auth_success_id_fk FOREIGN KEY (AuthSuccessId) REFERENCES auth_success (Id) ON DELETE CASCADE
) ENGINE = INNODB;

CREATE EVENT IF NOT EXISTS RemoveExpiredAuthSuccessEvent
ON SCHEDULE EVERY 1 DAY
DO DELETE FROM auth_success WHERE Expiry < UTC_TIMESTAMP();