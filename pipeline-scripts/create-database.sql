-- Creates the database for use with Opdex Platform API
DELIMITER //

DROP PROCEDURE IF EXISTS CreateDatabase;
//

CREATE PROCEDURE CreateDatabase ()
    BEGIN
        CREATE TABLE IF NOT EXISTS admin
        (
            Id      BIGINT UNSIGNED AUTO_INCREMENT,
            Address VARCHAR(50) NOT NULL,
            PRIMARY KEY (Id),
            UNIQUE admin_address_uq (Address)
        ) ENGINE=INNODB;

        CREATE TABLE IF NOT EXISTS auth_success(
            ConnectionId       VARCHAR(255) NOT NULL,
            Signer             VARCHAR(50) NOT NULL,
            Expiry             DATETIME NOT NULL,
            PRIMARY KEY (ConnectionId),
            INDEX auth_success_connection_id_ix (ConnectionId),
            INDEX auth_success_signer_ix (Signer)
        ) ENGINE = INNODB;

        CREATE TABLE IF NOT EXISTS auth_access_code(
            AccessCode         VARCHAR(50) NOT NULL,
            Signer             VARCHAR(50) NOT NULL,
            Expiry             DATETIME NOT NULL,
            PRIMARY KEY (AccessCode),
            INDEX auth_access_code_access_code_ix (AccessCode),
            INDEX auth_access_code_signer_ix (Signer)
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
