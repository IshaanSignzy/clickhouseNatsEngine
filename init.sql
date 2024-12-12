CREATE TABLE IF NOT EXISTS nats_messages
(
    `event_id` UUID DEFAULT generateUUIDv4(),  -- Automatically generate UUID if not provided
    `timestamp` DateTime,
    `event_type` String,
    `user_id` String,
    `ip_address` String
)
ENGINE = NATS
SETTINGS 
    nats_url = 'nats://nats:4222',
    nats_subjects = 'logs.audit',
    nats_format = 'JSONEachRow',  -- Expect JSONEachRow format
    date_time_input_format = 'best_effort';  -- Handle DateTime parsing


CREATE TABLE IF NOT EXISTS nats_messages_persisted
(
    `event_id` UUID,
    `timestamp` DateTime,
    `event_type` String,
    `user_id` String,
    `ip_address` String
)
ENGINE = MergeTree()
ORDER BY event_id;

CREATE MATERIALIZED VIEW nats_messages_mv TO nats_messages_persisted
AS 
SELECT 
    event_id,
    timestamp,
    event_type,
    user_id,
    ip_address
FROM nats_messages;
