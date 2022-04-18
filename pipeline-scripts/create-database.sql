-- Creates the database for use with Opdex Platform API
DELIMITER //

DROP PROCEDURE IF EXISTS CreateDatabase;
//

CREATE PROCEDURE CreateDatabase ()
    BEGIN
        CREATE TABLE IF NOT EXISTS code_challenge_method(
            Id      SMALLINT UNSIGNED AUTO_INCREMENT,
            Name    VARCHAR(5) NOT NULL,
            PRIMARY KEY (Id),
            UNIQUE code_challenge_method_name_uq (Name)
        ) ENGINE = INNODB;

        CREATE TABLE IF NOT EXISTS auth_session(
            Id                      BINARY(16) NOT NULL,
            Audience                VARCHAR(255) NOT NULL,
            CodeChallenge           VARCHAR(255) NOT NULL,
            CodeChallengeMethod     SMALLINT UNSIGNED NOT NULL,
            ConnectionId            VARCHAR(255) NULL,
            PRIMARY KEY (Id),
            UNIQUE auth_session_code_challenge_uq (CodeChallenge),
            UNIQUE auth_session_connection_id_uq (ConnectionId),
            CONSTRAINT auth_session_code_challenge_method_id_fk
                FOREIGN KEY (CodeChallengeMethod)
                REFERENCES code_challenge_method (Id)
        ) ENGINE = INNODB;

        CREATE TABLE IF NOT EXISTS auth_access_code(
            AccessCode         BINARY(16) NOT NULL,
            Signer             VARCHAR(50) NOT NULL,
            Stamp              BINARY(16) NOT NULL,
            Expiry             DATETIME NOT NULL,
            PRIMARY KEY (AccessCode),
            UNIQUE auth_access_code_stamp_uq (Stamp),
            INDEX auth_access_code_signer_ix (Signer),
            CONSTRAINT auth_access_code_stamp_fk
                FOREIGN KEY (Stamp)
                REFERENCES auth_session (Id) ON DELETE CASCADE
        ) ENGINE = INNODB;

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

        -- --------
        -- --------
        -- Populate Lookup Type Tables
        -- -------
        -- -------
        INSERT IGNORE INTO code_challenge_method(Name)
            VALUES ('Plain'), ('S256');
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

DROP EVENT IF EXISTS RemoveExpiredAuthAccessCodeEvent;

CREATE EVENT IF NOT EXISTS RemoveExpiredAuthAccessCodeEvent
ON SCHEDULE EVERY 5 MINUTE
DO DELETE FROM auth_access_code WHERE Expiry < UTC_TIMESTAMP();
//

DROP EVENT IF EXISTS RemoveExpiredAuthSuccessEvent;

CREATE EVENT IF NOT EXISTS RemoveExpiredAuthSuccessEvent
ON SCHEDULE EVERY 1 DAY
DO DELETE FROM auth_success WHERE Expiry < UTC_TIMESTAMP();
//

DELIMITER ;
