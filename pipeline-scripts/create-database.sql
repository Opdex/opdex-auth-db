-- Creates the database for use with Opdex Platform API
DELIMITER //

DROP PROCEDURE IF EXISTS CreateDatabase;
//

CREATE PROCEDURE CreateDatabase ()
    BEGIN
        CREATE TABLE IF NOT EXISTS auth_success(
            ConnectionId       VARCHAR(255) NOT NULL,
            Signer             VARCHAR(50) NOT NULL,
            Expiry             DATETIME NOT NULL,
            PRIMARY KEY (ConnectionId)
        ) ENGINE = INNODB;

        CREATE TABLE IF NOT EXISTS auth_access_code(
            Id                 BIGINT UNSIGNED AUTO_INCREMENT,
            AccessCode         VARCHAR(50) NOT NULL,
            Signer             VARCHAR(50) NOT NULL,
            Expiry             DATETIME NOT NULL,
            PRIMARY KEY (ConnectionId)
        ) ENGINE = INNODB;
    END;
//

CALL CreateDatabase();
//

DROP PROCEDURE CreateDatabase;
//

-- --------
-- --------
-- Events
-- --------
-- --------

DROP EVENT IF EXISTS RemoveExpiredAuthSuccessEvent;

CREATE EVENT IF NOT EXISTS RemoveExpiredAuthSuccessEvent
ON SCHEDULE EVERY 5 MINUTE
DO DELETE FROM auth_success WHERE Expiry < UTC_TIMESTAMP();
//

DROP EVENT IF EXISTS RemoveExpiredAuthAccessCodeEvent;

CREATE EVENT IF NOT EXISTS RemoveExpiredAuthAccessCodeEvent
ON SCHEDULE EVERY 5 MINUTE
DO DELETE FROM auth_access_code WHERE Expiry < UTC_TIMESTAMP();
//

DELIMITER ;
