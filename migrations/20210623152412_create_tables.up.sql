CREATE TABLE pg_chains (
    name     TEXT(32) NOT NULL,
    tip_hash BINARY(32) NOT NULL,

    UNIQUE KEY idx_nmae (name(32))
);

--bun:split

CREATE TABLE pg_blocks (
    hash              BINARY(32) PRIMARY KEY,
    parent_hash       BINARY(32),
    height            BIGINT NOT NULL,
    difficulty_target BINARY(32)  NOT NULL,
    cum_work          BINARY(32)  NOT NULL,
    status            TEXT   NOT NULL,
    tx_merkle_root    BINARY(32)  NOT NULL,
    timestamp         BIGINT NOT NULL,
    nonce             BIGINT NOT NULL,
    extra_nonce       BIGINT,
    version           INT,
    notified          BOOL NOT NULL
);

--bun:split

CREATE TABLE pg_transactions (
    hash       BINARY(32) PRIMARY KEY,
    block_hash BINARY(32) NOT NULL,
    type       SMALLINT NOT NULL,
    public_key BINARY(33),
    extra_data JSON,
    r          BINARY(32),
    s          BINARY(32)
);

--bun:split

CREATE TABLE pg_transaction_outputs (
    output_hash  BINARY(32)    NOT NULL,
    output_index INT      NOT NULL,
    output_type  SMALLINT NOT NULL,
    height       BIGINT   NOT NULL,
    public_key   BINARY(33)    NOT NULL,
    amount_nanos BIGINT   NOT NULL,
    spent        BOOL     NOT NULL,
    input_hash   BINARY(32),
    input_index  INT,

    PRIMARY KEY (output_hash, output_index)
);

--bun:split

CREATE INDEX pg_transaction_outputs_public_key ON pg_transaction_outputs (public_key);

--bun:split

CREATE TABLE pg_metadata_block_rewards (
    transaction_hash BINARY(32) PRIMARY KEY,
    extra_data       BINARY(32) NOT NULL
);

--bun:split

CREATE TABLE pg_metadata_bitcoin_exchanges (
    transaction_hash    BINARY(32) PRIMARY KEY,
    bitcoin_block_hash  BINARY(32) NOT NULL,
    bitcoin_merkle_root BINARY(32) NOT NULL
);

--bun:split

CREATE TABLE pg_metadata_private_messages (
    transaction_hash     BINARY(32) PRIMARY KEY,
    recipient_public_key BINARY(33)  NOT NULL,
    encrypted_text       MEDIUMBLOB  NOT NULL,
    timestamp_nanos      BIGINT NOT NULL
);

--bun:split

CREATE TABLE pg_metadata_submit_posts (
    transaction_hash    BINARY(32)  PRIMARY KEY,
    post_hash_to_modify BINARY(32)  NOT NULL,
    parent_stake_id     BINARY(32)  NOT NULL,
    body                MEDIUMTEXT  NOT NULL,
    timestamp_nanos     BIGINT NOT NULL,
    is_hidden           BOOL   NOT NULL
);

--bun:split

CREATE TABLE pg_metadata_update_exchange_rates (
    transaction_hash      BINARY(32) PRIMARY KEY,
    usd_cents_per_bitcoin BIGINT NOT NULL
);

--bun:split

CREATE TABLE pg_metadata_update_profiles (
    transaction_hash         BINARY(32) PRIMARY KEY,
    profile_public_key       BINARY(33),
    new_username             BINARY(32),
    new_description          BINARY(32),
    new_profile_pic          MEDIUMBLOB,
    new_creator_basis_points BIGINT NOT NULL
);

--bun:split

CREATE TABLE pg_metadata_follows (
    transaction_hash    BINARY(32) PRIMARY KEY,
    followed_public_key BINARY(33) NOT NULL,
    is_unfollow         BOOL NOT NULL
);

--bun:split

CREATE TABLE pg_metadata_likes (
    transaction_hash BINARY(32) PRIMARY KEY,
    liked_post_hash  BINARY(32) NOT NULL,
    is_unlike        BOOL NOT NULL
);

--bun:split

CREATE TABLE pg_metadata_creator_coins (
    transaction_hash                BINARY(32) PRIMARY KEY,
    profile_public_key              BINARY(33) NOT NULL,
    operation_type                  SMALLINT NOT NULL,
    deso_to_sell_nanos              BIGINT NOT NULL,
    creator_coin_to_sell_nanos      BIGINT NOT NULL,
    deso_to_add_nanos               BIGINT NOT NULL,
    min_deso_expected_nanos         BIGINT NOT NULL,
    min_creator_coin_expected_nanos BIGINT NOT NULL
);

--bun:split

CREATE TABLE pg_metadata_swap_identities (
    transaction_hash BINARY(32) PRIMARY KEY,
    from_public_key  BINARY(33) NOT NULL,
    to_public_key    BINARY(33) NOT NULL
);

--bun:split

CREATE TABLE pg_metadata_creator_coin_transfers (
    transaction_hash               BINARY(32) PRIMARY KEY,
    profile_public_key             BINARY(33) NOT NULL,
    creator_coin_to_transfer_nanos BIGINT NOT NULL,
    receiver_public_key            BINARY(33) NOT NULL
);

--bun:split

CREATE TABLE pg_metadata_create_nfts (
    transaction_hash             BINARY(32) PRIMARY KEY,
    nft_post_hash                BINARY(32) NOT NULL,
    num_copies                   BIGINT NOT NULL,
    has_unlockable               BOOL NOT NULL,
    is_for_sale                  BOOL NOT NULL,
    min_bid_amount_nanos         BIGINT NOT NULL,
    creator_royalty_basis_points BIGINT NOT NULL,
    coin_royalty_basis_points    BIGINT NOT NULL
);

--bun:split

CREATE TABLE pg_metadata_update_nfts (
    transaction_hash     BINARY(32) PRIMARY KEY,
    nft_post_hash        BINARY(32) NOT NULL,
    serial_number        BIGINT NOT NULL,
    is_for_sale          BOOL NOT NULL,
    min_bid_amount_nanos BIGINT NOT NULL
);

--bun:split

CREATE TABLE pg_metadata_accept_nft_bids (
    transaction_hash BINARY(32) PRIMARY KEY,
    nft_post_hash    BINARY(32) NOT NULL,
    serial_number    BIGINT NOT NULL,
    bidder_pkid      BINARY(33) NOT NULL,
    bid_amount_nanos BIGINT NOT NULL,
    unlockable_text  BINARY(32) NOT NULL
);

--bun:split

CREATE TABLE pg_metadata_bid_inputs (
    transaction_hash BINARY(32) NOT NULL,
    input_hash       BINARY(32) NOT NULL,
    input_index      BIGINT NOT NULL,

    PRIMARY KEY (transaction_hash, input_hash, input_index)
);

--bun:split

CREATE TABLE pg_metadata_nft_bids (
    transaction_hash BINARY(32) PRIMARY KEY,
    nft_post_hash    BINARY(32) NOT NULL,
    serial_number    BIGINT NOT NULL,
    bid_amount_nanos BIGINT NOT NULL
);

--bun:split

CREATE TABLE pg_notifications (
    transaction_hash BINARY(32) PRIMARY KEY,
    mined            BOOL NOT NULL,
    to_user          BINARY(32) NOT NULL,
    from_user        BINARY(32) NOT NULL,
    other_user       BINARY(32),
    type             SMALLINT NOT NULL,
    amount           BIGINT,
    post_hash        BINARY(32),
    timestamp        BIGINT NOT NULL
);

--bun:split

CREATE TABLE pg_profiles (
    pkid                       BINARY(33) PRIMARY KEY,
    public_key                 BINARY(33) NOT NULL,
    username                   TEXT(25),
    description                TEXT,
    profile_pic                MEDIUMBLOB,
    creator_basis_points       BIGINT,
    deso_locked_nanos          BIGINT,
    number_of_holders          BIGINT,
    coins_in_circulation_nanos BIGINT,
    coin_watermark_nanos       BIGINT
);

--bun:split

CREATE INDEX pg_profiles_public_key ON pg_profiles (public_key);

--bun:split

CREATE INDEX pg_profiles_username ON pg_profiles (username(25));

--bun:split

CREATE INDEX pg_profiles_lower_username ON pg_profiles ((LOWER(username)));

--bun:split

CREATE TABLE pg_posts (
    post_hash                    BINARY(32) PRIMARY KEY,
    poster_public_key            BINARY(33) NOT NULL,
    parent_post_hash             BINARY(32),
    body                         MEDIUMTEXT,
    reposted_post_hash           BINARY(32),
    quoted_repost                BOOL,
    timestamp                    BIGINT,
    hidden                       BOOL,
    like_count                   BIGINT,
    repost_count                 BIGINT,
    quote_repost_count           BIGINT,
    diamond_count                BIGINT,
    comment_count                BIGINT,
    pinned                       BOOL,
    nft                          BOOL,
    num_nft_copies               BIGINT,
    unlockable                   BOOL,
    creator_royalty_basis_points BIGINT,
    coin_royalty_basis_points    BIGINT,
    extra_data                   JSON,
    num_nft_copies_for_sale      BIGINT,
    num_nft_copies_burned        BIGINT
);

--bun:split

CREATE TABLE pg_likes (
    liker_public_key BINARY(33),
    liked_post_hash  BINARY(32),

    PRIMARY KEY (liker_public_key, liked_post_hash)
);

--bun:split

CREATE TABLE pg_follows (
    follower_pkid BINARY(33),
    followed_pkid BINARY(33),

    PRIMARY KEY (follower_pkid, followed_pkid)
);

--bun:split

CREATE TABLE pg_diamonds (
    sender_pkid       BINARY(33),
    receiver_pkid     BINARY(33),
    diamond_post_hash BINARY(32),
    diamond_level     SMALLINT,

    PRIMARY KEY (sender_pkid, receiver_pkid, diamond_post_hash)
);

--bun:split

CREATE TABLE pg_messages (
    message_hash         BINARY(32) PRIMARY KEY,
    sender_public_key    BINARY(33),
    recipient_public_key BINARY(33),
    encrypted_text       MEDIUMBLOB,
    timestamp_nanos      BIGINT
);

--bun:split

CREATE TABLE pg_creator_coin_balances (
    holder_pkid   BINARY(33),
    creator_pkid  BINARY(33),
    balance_nanos BIGINT UNSIGNED,
    has_purchased BOOL,

    PRIMARY KEY (holder_pkid, creator_pkid)
);

--bun:split

CREATE TABLE pg_balances (
    public_key    BINARY(33) PRIMARY KEY,
    balance_nanos BIGINT UNSIGNED
);

--bun:split

CREATE TABLE pg_global_params (
    id                           BIGINT PRIMARY KEY,
    usd_cents_per_bitcoin        BIGINT,
    create_profile_fee_nanos     BIGINT,
    create_nft_fee_nanos         BIGINT,
    max_copies_per_nft           BIGINT,
    min_network_fee_nanos_per_kb BIGINT
);

--bun:split

CREATE TABLE pg_reposts (
    reposter_public_key BINARY(33),
    reposted_post_hash  BINARY(32),
    repost_post_hash    BINARY(32),

    PRIMARY KEY (reposter_public_key, reposted_post_hash)
);

--bun:split

CREATE TABLE pg_forbidden_keys (
    public_key BINARY(33) PRIMARY KEY
);

--bun:split

CREATE TABLE pg_nfts (
    nft_post_hash                  BINARY(32),
    serial_number                  BIGINT,
    last_owner_pkid                BINARY(33),
    owner_pkid                     BINARY(33),
    for_sale                       BOOL,
    min_bid_amount_nanos           BIGINT,
    unlockable_text                TEXT,
    last_accepted_bid_amount_nanos BIGINT,
    is_pending BOOL,

    PRIMARY KEY (nft_post_hash, serial_number)
);

--bun:split

CREATE TABLE pg_nft_bids (
    bidder_pkid      BINARY(33),
    nft_post_hash    BINARY(32),
    serial_number    BIGINT,
    bid_amount_nanos BIGINT,
    accepted         BOOL,

    PRIMARY KEY (bidder_pkid, nft_post_hash, serial_number)
);

--bun:split

CREATE TABLE pg_metadata_derived_keys (
    transaction_hash   BINARY(32) PRIMARY KEY,
    derived_public_key BINARY(33) NOT NULL,
    expiration_block   BIGINT NOT NULL,
    operation_type     SMALLINT NOT NULL,
    access_signature   BINARY(32) NOT NULL
);

--bun:split

CREATE TABLE pg_derived_keys (
    owner_public_key   BINARY(33) NOT NULL,
    derived_public_key BINARY(33) NOT NULL,
    expiration_block   BIGINT NOT NULL,
    operation_type     SMALLINT NOT NULL,

    PRIMARY KEY (owner_public_key, derived_public_key)
);

--bun:split

CREATE TABLE pg_metadata_nft_transfer (
    transaction_hash    BINARY(32) PRIMARY KEY,
    nft_post_hash       BINARY(32) NOT NULL,
    serial_number       BIGINT NOT NULL,
    receiver_public_key BINARY(33) NOT NULL,
    unlockable_text     BINARY(32) NOT NULL
);

--bun:split

CREATE TABLE pg_metadata_accept_nft_transfer (
    transaction_hash BINARY(32) PRIMARY KEY,
    nft_post_hash    BINARY(32) NOT NULL,
    serial_number    BIGINT NOT NULL
);

--bun:split

CREATE TABLE pg_metadata_burn_nft (
    transaction_hash BINARY(32) PRIMARY KEY,
    nft_post_hash    BINARY(32) NOT NULL,
    serial_number    BIGINT NOT NULL
);
