drop schema if exists axum;

create schema if not exists axum;

create table if not exists `axum`.`users`
(
    `id`         bigint unsigned not null auto_increment primary key,
    `key`        binary(25)      not null,
    `first_name` varchar(255),
    `last_name`  varchar(255)    not null,
    `email`      varchar(255)    not null,
    `created_at` datetime(6)     not null default current_timestamp(6),
    `updated_at` datetime(6)     not null default current_timestamp(6),
    `deleted_at` datetime(6)
);

create index users_deleted_at_idx on `axum`.`users` (`deleted_at`);
create index users_email_idx on `axum`.`users` (`email`);
create index users_key_idx on `axum`.`users` (`key`);

create table if not exists `axum`.`address`
(
    `id`         bigint unsigned not null auto_increment primary key,
    `key`        binary(25)      not null,
    `user_id`    bigint unsigned not null,
    `line_one`   varchar(255)    not null,
    `line_two`   varchar(255),
    `city`       varchar(255)    not null,
    `state`      varchar(50)     not null,
    `country`    varchar(2)      not null,
    `geocode`    JSON            NOT NULL,
    `created_at` datetime(6)     not null default current_timestamp(6),
    `updated_at` datetime(6)     not null default current_timestamp(6),
    `deleted_at` datetime(6)
);

create index address_city_idx on `axum`.`address` (`city`);
create index address_state_idx on `axum`.`address` (`state`);
create index address_country_idx on `axum`.`address` (`country`);
create index address_deleted_at_idx on `axum`.`address` (`deleted_at`);
create index address_key on `axum`.`address` (`key`);

alter table `axum`.`address`
    add constraint fk_address_users_user_id foreign key (`user_id`) references `axum`.`users` (`id`);

create table `axum`.`events`
(
    `id`       bigint unsigned                not null auto_increment primary key,
    `type`     enum ('User', 'Auth', 'Other') not null,
    `name`     varchar(255)                   not null,
    `info`     json,
    `time`     datetime(6)                    not null default current_timestamp(6),
    `user_id`  bigint unsigned
);

create index event_type_idx on `axum`.`events` (`type`);
create index event_name_idx on `axum`.`events` (`name`);
create index event_type_name_idx on `axum`.`events` (`type`, `name`);
create index event_time_idx on `axum`.`events` (`time`);

alter table `axum`.`events`
    add constraint fk_event_users_user_id foreign key (`user_id`) references `axum`.`users` (`id`);