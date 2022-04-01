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

        CREATE TABLE auth_access_code(
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

        -- --------
        -- --------
        -- Populate Lookup Type Tables
        -- -------
        -- -------
        INSERT INTO code_challenge_method(Name)
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

DELIMITER ;
