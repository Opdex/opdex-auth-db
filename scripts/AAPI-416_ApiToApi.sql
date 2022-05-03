ALTER TABLE auth_session MODIFY Audience VARCHAR(255);
ALTER TABLE auth_session MODIFY CodeChallenge VARCHAR(255);
ALTER TABLE auth_session MODIFY CodeChallengeMethod SMALLINT UNSIGNED;