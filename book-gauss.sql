create database book owner fantastic;

-- 以上在命令行中以omm用户执行

-- 以下在data studio中以fantastic用户执行
create schema book;

set search_path to book;

create table SPRING_SESSION
(
    PRIMARY_ID            char(36)     not null primary key,
    SESSION_ID            char(36)     not null,
    CREATION_TIME         bigint       not null,
    LAST_ACCESS_TIME      bigint       not null,
    MAX_INACTIVE_INTERVAL int          not null,
    EXPIRY_TIME           bigint       not null,
    PRINCIPAL_NAME        varchar(100) null
);

create table SPRING_SESSION_ATTRIBUTES
(
    SESSION_PRIMARY_ID char(36)     not null primary key,
    ATTRIBUTE_NAME     varchar(200) not null,
    ATTRIBUTE_BYTES bytea not null
);

CREATE
SEQUENCE sq_book_id
 START
1
 INCREMENT 1
 CACHE
20;

create table book
(
    book_id     int primary key DEFAULT nextval('sq_book_id'),
    book_name   varchar(50) not null,
    book_author varchar(50) not null,
    isbn        varchar(20) not null,
    stock       int         not null
);

create table book_detail
(
    book_id      int          not null
        primary key,
    book_name    varchar(50)  not null,
    book_author  varchar(50)  not null,
    publisher    varchar(50)  not null,
    time         varchar(10)  not null,
    image        varchar(100) null,
    introduction text         null,
    constraint book_detail_book_null_fk
        foreign key (book_id) references book (book_id)
);

CREATE
SEQUENCE sq_user_id
 START
1
 INCREMENT 1
 CACHE
20;

-- 表名称不能为user
create table u_user
(
    user_id   int primary key DEFAULT nextval('sq_user_id'),
    user_name varchar(50)  null,
    password  varchar(100) null,
    age       int          null,
    sex       varchar(5)   null,
    phone     varchar(30)  null
);

insert into u_user(user_name,password,age,sex,phone)
values
    ('admin', '$2a$10$M9n/9O5qXuqtjup4jm3Oz.qj393pQ2eR/fS6/Amkf/MqbxgmjE9/K', 18, '男', '13122223333'),
    ('bob', '$2a$10$FRuiYpdeF.AY98Q0GVJuE.hnYWc/a0K7aJN1LGXDHc.0ewyUSc7I6', 22, '女', '15933334444');

create table borrow_info
(
    user_id     int         not null,
    user_name   varchar(50) not null,
    book_id     int         not null,
    book_name   varchar(50) not null,
    borrow_time bigint      not null,
    deadline    bigint      not null,
    primary key (book_id, user_id),
    constraint borrow_info_book_null_fk
        foreign key (book_id) references book (book_id),
    constraint borrow_info_user_null_fk
        foreign key (user_id) references u_user (user_id)
);

create table user_log
(
    log_id      int          null,
    user_id     smallint     null,
    role_id     tinyint      null,
    action_time timestamp    null,
    action_type tinyint      null,
    description varchar(200) null,
    user_name   varchar(50)  null,
    role_name   varchar(50)  null
);

-- role
create table r_role
(
    role_id   tinyint primary key,
    role_name varchar(50) null
);

insert into r_role
values
    (1, '管理员（全部操作）'),
    (2, '普通用户（仅查看）');

CREATE
SEQUENCE sq_user_role_id
 START
1
 INCREMENT 1
 CACHE
20;

create table user_role
(
    id      int primary key DEFAULT nextval('sq_user_role_id'),
    user_id smallint not null,
    role_id tinyint  not null
);

alter table user_role
    add foreign key (user_id)
        references u_user (user_id);

alter table user_role
    add foreign key (role_id)
        references r_role (role_id);
        
-- user_role
insert into user_role(user_id,role_id)
values
    (1, 1),
    (2, 2);

-- privilege
create table privilege
(
    privilege_id   smallint primary key,
    privilege_name varchar(50) null
);

insert into privilege
values
    (1, '查看数据'),
    (2, '增删改数据');

-- role_privilege
create table role_privilege
(
    id           int      not null primary key,
    role_id      tinyint  not null,
    privilege_id smallint not null
);

alter table role_privilege
    add foreign key (role_id)
        references r_role (role_id);

alter table role_privilege
    add foreign key (privilege_id)
        references privilege (privilege_id);

insert into role_privilege
values
    (1, 1, 1),
    (2, 1, 2),
    (3, 2, 1);
