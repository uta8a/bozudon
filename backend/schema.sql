CREATE TABLE account (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    username VARCHAR(256) NOT NULL,
    domain VARCHAR(256),
    display_name VARCHAR(256) NOT NULL,
    note VARCHAR(256) NOT NULL,
    uri VARCHAR(256) NOT NULL UNIQUE,
    url VARCHAR(256),
    inbox_url VARCHAR(256) NOT NULL,
    outbox_url VARCHAR(256) NOT NULL,
    shared_inbox_url VARCHAR(256) NOT NULL,
    followers_url VARCHAR(256) NOT NULL,
    private_key TEXT,
    public_key TEXT NOT NULL
);
CREATE UNIQUE INDEX ON account (
    LOWER(username), COALESCE(LOWER(domain), '')
);

CREATE TABLE user_ (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    email VARCHAR(256) NOT NULL,
    encrypted_password VARCHAR(256) NOT NULL,
    account_id BIGINT NOT NULL REFERENCES account(id)
);

CREATE TABLE media (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    key VARCHAR(256) NOT NULL UNIQUE,
    preview_key VARCHAR(256) NOT NULL,
    media_type VARCHAR(256) NOT NULL,
    description VARCHAR(256) NOT NULL,
    blurhash VARCHAR(256),
    remote_url VARCHAR(256),
    resource_owner_id BIGINT REFERENCES user_(id)
);

CREATE TABLE status (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    text TEXT NOT NULL,
    in_reply_to_id BIGINT REFERENCES status(id),
    reblog_of_id BIGINT REFERENCES status(id),
    account_id BIGINT NOT NULL REFERENCES account(id),
    uri VARCHAR(256) NOT NULL UNIQUE,
    url VARCHAR(256),
    media_ids BIGINT[] NOT NULL,

    UNIQUE (reblog_of_id, account_id)
);

CREATE TABLE follow (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    account_id BIGINT NOT NULL REFERENCES account(id),
    target_account_id BIGINT NOT NULL REFERENCES account(id),
    UNIQUE (account_id, target_account_id)
);

CREATE TABLE favorite (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    account_id BIGINT NOT NULL REFERENCES account(id),
    status_id BIGINT NOT NULL REFERENCES status(id),

    UNIQUE (account_id, status_id)
);

CREATE TABLE app (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    name VARCHAR(256) NOT NULL,
    redirect_uri VARCHAR(256) NOT NULL,
    scopes VARCHAR(256) NOT NULL,
    website VARCHAR(256),
    client_id VARCHAR(256) NOT NULL,
    client_secret VARCHAR(256) NOT NULL
);

CREATE TABLE oauth_access_grant (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    token VARCHAR(256) NOT NULL UNIQUE,
    expires_in TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    redirect_uri VARCHAR(256) NOT NULL,
    scopes VARCHAR(256) NOT NULL,
    app_id BIGINT NOT NULL REFERENCES app(id),
    resource_owner_id BIGINT REFERENCES user_(id)
);

CREATE TABLE oauth_access_token (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    token VARCHAR(256) NOT NULL UNIQUE,
    scopes VARCHAR(256) NOT NULL,
    app_id BIGINT NOT NULL REFERENCES app(id),
    resource_owner_id BIGINT NOT NULL REFERENCES user_(id)
);
