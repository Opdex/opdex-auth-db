DROP TABLE IF EXISTS auth_session;

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