create extension if not exists "uuid-ossp";
create schema if not exists blocklist;

create table if not exists blocklist
(
    id              uuid                     default uuid_generate_v4() not null
        constraint blocklist_pk primary key,
    name            varchar(255)                                        not null unique,
    format          varchar(255)                                        not null,
    download_url    varchar(255)                                        not null unique,
    homepage_url    varchar(255)                                        not null,
    issues_url      varchar(255)                                        not null,
    license_url     varchar(255),
    license_type    varchar(255)                                        not null
);

create table if not exists version
(
    id uuid default     uuid_generate_v4()                             not null
        constraint version_pk primary key,
    blocklist_id        uuid                                           not null
        references blocklist(id) on delete cascade,
    num_entries         bigint                      default 0          not null,
    raw_sha256          varchar(255)                                   not null,
    parsed_sha256       varchar(255)                                   not null,
    created_on          timestamp with time zone    default now()      not null,
    last_seen           timestamp with time zone    default now()      not null,
    is_fully_loaded     boolean                                        not null
);

create table if not exists entry
(
    id                  uuid default     uuid_generate_v4()            not null
        constraint entry_pk primary key,
    value               varchar(255)                                   not null unique
);

create table if not exists entry_period
(
    id                  uuid default     uuid_generate_v4()            not null
        constraint entry_period_pk primary key,
    blocklist_id        uuid                                           not null
        references blocklist(id) on delete cascade,
    entry_id            uuid                                           not null
        references entry(id) on delete cascade,
    start_version_id    uuid                                           not null
        references version(id) on delete cascade,
    end_version_id      uuid
        references version(id) on delete set null
);

create table if not exists list_tag
(
    id                   uuid default     uuid_generate_v4()           not null
        constraint list_tag_pk primary key,
    blocklist_id         uuid                                          not null
        references blocklist(id) on delete cascade,
    value                varchar(255)                                  not null
);

CREATE OR REPLACE VIEW entry_period_with_dates as
SELECT ep.*,
       sv.created_on AS period_start,
       ev.created_on AS period_end
FROM entry_period ep
         LEFT JOIN version sv ON ep.start_version_id = sv.id
         LEFT JOIN version ev ON ep.end_version_id = sv.id;


create unique index if not exists version_blocklist_id_created_on_uindex
    on version(blocklist_id, created_on);

create unique index if not exists version_blocklist_id_last_seen_uindex
    on version(blocklist_id, last_seen);

create unique index if not exists list_tag_blocklist_id_value_uindex
    on list_tag(blocklist_id, value);

-- searching for all lists containing a entry
create index if not exists entry_period_entry_id_index
    on entry_period(entry_id);

create unique index if not exists entry_period_entry_id_start_version_id_uindex
    on entry_period(entry_id, start_version_id);

create unique index if not exists entry_period_entry_id_end_version_id_uindex
    on entry_period(entry_id, end_version_id);


-- Developer Dan: Ads & Tracking
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('d4440ca2-be75-4dd0-80ea-ddbefe1d0509',
        'Developer Dan: Ads & Tracking',
        'hosts',
        'https://www.github.developerdan.com/hosts/lists/ads-and-tracking-extended.txt',
        'https://www.github.developerdan.com/hosts/',
        'https://github.com/lightswitch05/hosts/issues',
        'https://github.com/lightswitch05/hosts/blob/master/LICENSE',
        'Apache-2.0')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('d4440ca2-be75-4dd0-80ea-ddbefe1d0509', 'source')
on conflict do nothing;


-- Developer Dan: Tracking Aggressive
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('cf95625f-2d92-43bb-a161-3f03982987af',
        'Developer Dan: Tracking Aggressive',
        'hosts',
        'https://www.github.developerdan.com/hosts/lists/tracking-aggressive-extended.txt',
        'https://www.github.developerdan.com/hosts/',
        'https://github.com/lightswitch05/hosts/issues',
        'https://github.com/lightswitch05/hosts/blob/master/LICENSE',
        'Apache-2.0')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('cf95625f-2d92-43bb-a161-3f03982987af', 'source')
on conflict do nothing;


-- Developer Dan: AMP Hosts
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('522f16bb-9cd9-4e94-b2b7-5aae18a82b52',
        'Developer Dan: AMP Hosts',
        'hosts',
        'https://www.github.developerdan.com/hosts/lists/amp-hosts-extended.txt',
        'https://www.github.developerdan.com/hosts/',
        'https://github.com/lightswitch05/hosts/issues',
        'https://github.com/lightswitch05/hosts/blob/master/LICENSE',
        'Apache-2.0')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('522f16bb-9cd9-4e94-b2b7-5aae18a82b52', 'source')
on conflict do nothing;


-- Developer Dan: Facebook
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('ce9c6ec5-13b5-4018-90e2-462b999362c2',
        'Developer Dan: Facebook',
        'hosts',
        'https://www.github.developerdan.com/hosts/lists/facebook-extended.txt',
        'https://www.github.developerdan.com/hosts/',
        'https://github.com/lightswitch05/hosts/issues',
        'https://github.com/lightswitch05/hosts/blob/master/LICENSE',
        'Apache-2.0')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('ce9c6ec5-13b5-4018-90e2-462b999362c2', 'source')
on conflict do nothing;


-- Developer Dan: Hate & Junk
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('afee319e-f434-4abf-96ae-f580493707ed',
        'Developer Dan: Hate & Junk',
        'hosts',
        'https://www.github.developerdan.com/hosts/lists/hate-and-junk-extended.txt',
        'https://www.github.developerdan.com/hosts/',
        'https://github.com/lightswitch05/hosts/issues',
        'https://github.com/lightswitch05/hosts/blob/master/LICENSE',
        'Apache-2.0')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('afee319e-f434-4abf-96ae-f580493707ed', 'source')
on conflict do nothing;


-- Steven Black Hosts: Unified
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('67701e59-0496-4332-9586-aeb4db1cd097',
        'Steven Black Hosts: Unified',
        'hosts',
        'https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts',
        'https://github.com/StevenBlack/hosts',
        'https://github.com/StevenBlack/hosts/issues',
        'https://github.com/StevenBlack/hosts/blob/master/license.txt',
        'MIT')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('67701e59-0496-4332-9586-aeb4db1cd097', 'unified')
on conflict do nothing;


-- AdAway
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('542f85d5-bc71-43ed-9430-1c820dd32059',
        'AdAway',
        'hosts',
        'https://raw.githubusercontent.com/AdAway/adaway.github.io/master/hosts.txt',
        'https://adaway.org/',
        'https://github.com/AdAway/adaway.github.io/issues',
        'https://github.com/AdAway/adaway.github.io/blob/master/LICENSE.md',
        'CC BY 3.0')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('542f85d5-bc71-43ed-9430-1c820dd32059', 'source')
on conflict do nothing;


-- OISD: Domain Normal
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_type)
values ('1467029f-0ace-4b3a-9a90-00f60475015b',
        'OISD: Domain Normal',
        'domain',
        'https://dbl.oisd.nl/',
        'https://oisd.nl/',
        'https://oisd.nl/?p=fp',
        'All rights reserved')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('1467029f-0ace-4b3a-9a90-00f60475015b', 'unified')
on conflict do nothing;


-- OISD: Domain Light
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_type)
values ('93b945d3-5005-4bd9-8faf-f2bb1a16831c',
        'OISD: Domain Light',
        'domain',
        'https://dbl.oisd.nl/light/',
        'https://oisd.nl/',
        'https://oisd.nl/?p=fp',
        'All rights reserved')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('93b945d3-5005-4bd9-8faf-f2bb1a16831c', 'unified')
on conflict do nothing;


-- Llacb47 mischosts: TikTok Block
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('2f8d3438-750b-45d2-84b4-655202eb11f9',
        'Llacb47 mischosts: TikTok Block',
        'hosts',
        'https://raw.githubusercontent.com/llacb47/mischosts/master/social/tiktok-block',
        'https://github.com/llacb47/mischosts',
        'https://github.com/llacb47/mischosts/issues',
        'https://github.com/llacb47/mischosts/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('2f8d3438-750b-45d2-84b4-655202eb11f9', 'source')
on conflict do nothing;


-- Llacb47 mischosts: Blacklist
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('91a41894-bfbc-4000-81be-178ca0691fdf',
        'Llacb47 mischosts: Blacklist',
        'hosts',
        'https://raw.githubusercontent.com/llacb47/mischosts/master/blacklist',
        'https://github.com/llacb47/mischosts',
        'https://github.com/llacb47/mischosts/issues',
        'https://github.com/llacb47/mischosts/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('91a41894-bfbc-4000-81be-178ca0691fdf', 'source')
on conflict do nothing;


-- RiskAnalytics: Malware Domain Blocklist
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('390cfeb8-2e4f-4a5c-9dd0-92dd63fc8a86',
        'RiskAnalytics: Malware Domain Blocklist',
        'domain',
        'https://mirror1.malwaredomains.com/files/justdomains',
        'http://www.malwaredomains.com/',
        'http://www.malwaredomains.com/?page_id=13',
        'http://www.malwaredomains.com/?page_id=1508',
        'Noncommercial')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('390cfeb8-2e4f-4a5c-9dd0-92dd63fc8a86', 'source')
on conflict do nothing;


-- PolishFiltersTeam: KADhosts
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('2087f7a9-e6b7-4e64-ac76-8072c5791e08',
        'PolishFiltersTeam: KADhosts',
        'hosts',
        'https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts_without_controversies.txt',
        'https://kadantiscam.netlify.app/',
        'https://github.com/PolishFiltersTeam/KADhosts/issues',
        'https://github.com/PolishFiltersTeam/KADhosts/blob/master/LICENSE',
        'Creative Commons Attribution-ShareAlike 4.0 International')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('2087f7a9-e6b7-4e64-ac76-8072c5791e08', 'source')
on conflict do nothing;


-- Fademind: Spammers
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('1366ea8c-11e3-4070-9e1c-0b889ccfcd54',
        'Fademind: Spammers',
        'hosts',
        'https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts',
        'https://github.com/FadeMind/hosts.extras',
        'https://github.com/FadeMind/hosts.extras/issues',
        'https://github.com/FadeMind/hosts.extras/blob/master/COPYING',
        'MIT')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('1366ea8c-11e3-4070-9e1c-0b889ccfcd54', 'source')
on conflict do nothing;


-- WaLLy3K: Blacklist
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('2964d90d-cdf5-422e-986d-609bf1dada23',
        'WaLLy3K: Blacklist',
        'domain',
        'https://v.firebog.net/hosts/static/w3kbl.txt',
        'https://firebog.net/about',
        'https://github.com/WaLLy3K/wally3k.github.io/issues',
        'http://creativecommons.org/licenses/by-nc/4.0/',
        'CC BY-NC 4.0')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('2964d90d-cdf5-422e-986d-609bf1dada23', 'source')
on conflict do nothing;


-- Matomo: Referrer Spam
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('e84113ae-8ee8-423c-8efe-78468dc5ed85',
        'Matomo: Referrer Spam',
        'domain',
        'https://raw.githubusercontent.com/matomo-org/referrer-spam-blacklist/master/spammers.txt',
        'https://github.com/matomo-org/referrer-spam-list',
        'https://github.com/matomo-org/referrer-spam-list/issues',
        'https://github.com/matomo-org/referrer-spam-list/blob/master/README.md',
        'Public Domain (no copyright)')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('e84113ae-8ee8-423c-8efe-78468dc5ed85', 'source')
on conflict do nothing;


-- Dan Pollock: someonewhocares
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('01f605f6-8a7d-4d78-9ffa-780a69924271',
        'Dan Pollock: someonewhocares',
        'hosts',
        'https://someonewhocares.org/hosts/zero/hosts',
        'https://someonewhocares.org/hosts/',
        'https://someonewhocares.org/hosts/',
        'https://someonewhocares.org/hosts/',
        'Non-commercial with attribution')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('01f605f6-8a7d-4d78-9ffa-780a69924271', 'source')
on conflict do nothing;


-- Vokins: yhosts
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('cb919bdb-9842-408a-ace1-bdf71d5ce3e4',
        'Vokins: yhosts',
        'hosts',
        'https://raw.githubusercontent.com/vokins/yhosts/master/hosts',
        'https://github.com/vokins/yhosts',
        'https://github.com/vokins/yhosts/issues',
        'https://creativecommons.org/licenses/by-nc-nd/4.0/',
        'Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('cb919bdb-9842-408a-ace1-bdf71d5ce3e4', 'source')
on conflict do nothing;



-- Winhelp2002 MVPS
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('af813f51-0846-47d0-98a4-744f4652fa48',
        'Winhelp2002 MVPS',
        'hosts',
        'https://winhelp2002.mvps.org/hosts.txt',
        'https://winhelp2002.mvps.org/hosts.txt',
        'https://winhelp2002.mvps.org/hosts.txt',
        'https://creativecommons.org/licenses/by-nc-sa/4.0/',
        'Creative Commons Attribution-NonCommercial-ShareAlike License')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('af813f51-0846-47d0-98a4-744f4652fa48', 'source')
on conflict do nothing;


-- NeoFelhz: neoHosts Basic
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('ac25a759-509c-4290-9e5c-dd5f60f4963f',
        'NeoFelhz: neoHosts Basic',
        'hosts',
        'https://cdn.jsdelivr.net/gh/neoFelhz/neohosts@gh-pages/basic/hosts',
        'https://github.com/neofelhz/neohosts',
        'https://github.com/neofelhz/neohosts/issues',
        'https://github.com/neofelhz/neohosts/blob/data/LICENSE',
        'MIT')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('ac25a759-509c-4290-9e5c-dd5f60f4963f', 'source')
on conflict do nothing;



-- NeoFelhz: neoHosts Full
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('76c109c7-7e28-4c81-9977-762019642d7f',
        'NeoFelhz: neoHosts Full',
        'hosts',
        'https://cdn.jsdelivr.net/gh/neoFelhz/neohosts@gh-pages/full/hosts',
        'https://github.com/neofelhz/neohosts',
        'https://github.com/neofelhz/neohosts/issues',
        'https://github.com/neofelhz/neohosts/blob/data/LICENSE',
        'MIT')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('76c109c7-7e28-4c81-9977-762019642d7f', 'source')
on conflict do nothing;

-- RooneyMcNibNug: SNAFU list
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('7572fce7-b6a6-42fd-9855-62e302c430b3',
        'RooneyMcNibNug: SNAFU list',
        'domain',
        'https://raw.githubusercontent.com/RooneyMcNibNug/pihole-stuff/master/SNAFU.txt',
        'https://github.com/RooneyMcNibNug/pihole-stuff/issues',
        'https://github.com/neofelhz/neohosts/issues',
        'http://www.wtfpl.net/about/',
        'WTFPL')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('7572fce7-b6a6-42fd-9855-62e302c430b3', 'source')
on conflict do nothing;



-- Adguard: DNS
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('8ebd22b6-81a7-4f6e-8032-6f7ad281b9b7',
        'Adguard: DNS',
        'domain',
        'https://v.firebog.net/hosts/AdguardDNS.txt',
        'https://github.com/AdguardTeam/AdguardSDNSFilter',
        'https://github.com/AdguardTeam/AdguardSDNSFilter/issues',
        'https://github.com/AdguardTeam/AdguardSDNSFilter/blob/master/LICENSE',
        'GNU General Public License v3.0')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('8ebd22b6-81a7-4f6e-8032-6f7ad281b9b7', 'source')
on conflict do nothing;


-- LanikSJ: Admiral Anti-Adblock
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('cb51c11f-0086-422f-a2ea-0313f910ec6e',
        'LanikSJ: Admiral Anti-Adblock',
        'domain',
        'https://v.firebog.net/hosts/Admiral.txt',
        'https://github.com/LanikSJ/ubo-filters',
        'https://github.com/LanikSJ/ubo-filters/issues',
        'https://opensource.org/licenses/MIT',
        'MIT')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('cb51c11f-0086-422f-a2ea-0313f910ec6e', 'source')
on conflict do nothing;


-- Anudeep ND: Blacklist
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('1d28491c-6892-4615-974f-0f546da72474',
        'Anudeep ND: Blacklist',
        'hosts',
        'https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt',
        'https://github.com/anudeepND/blacklist',
        'https://github.com/anudeepND/blacklist/issues',
        'https://github.com/anudeepND/blacklist/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('1d28491c-6892-4615-974f-0f546da72474', 'source')
on conflict do nothing;


-- Anudeep ND: Whitelist
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('28a8cefc-9b7c-4f71-bc1e-38a6242d5840',
        'Anudeep ND: Whitelist',
        'domain',
        'https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt',
        'https://github.com/anudeepND/whitelist',
        'https://github.com/anudeepND/whitelist/issues',
        'https://github.com/anudeepND/whitelist/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('28a8cefc-9b7c-4f71-bc1e-38a6242d5840', 'source')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('28a8cefc-9b7c-4f71-bc1e-38a6242d5840', 'allowlist')
on conflict do nothing;


-- Disconnect: Ads
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('c18393b3-166c-4fd5-8726-ae8ced850dbb',
        'Disconnect: Ads',
        'domain',
        'https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt',
        'https://disconnect.me',
        'https://disconnect.me/about',
        'https://www.gnu.org/licenses/gpl-3.0.en.html',
        'GPLv3')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('c18393b3-166c-4fd5-8726-ae8ced850dbb', 'source')
on conflict do nothing;


-- Easylist: easylist
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('14163f82-33d8-4d41-9d3e-4d27f9efdcef',
        'Easylist: easylist',
        'domain',
        'https://v.firebog.net/hosts/Easylist.txt',
        'https://easylist.to/',
        'https://forums.lanik.us/',
        'http://creativecommons.org/licenses/by/3.0/',
        'Attribution 3.0 Unported')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('c18393b3-166c-4fd5-8726-ae8ced850dbb', 'source')
on conflict do nothing;


-- Peter Lowe: Adservers
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('6448c43b-b9ba-4629-bd61-8659840f4f38',
        'Peter Lowe: Adservers',
        'hosts',
        'https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext',
        'https://pgl.yoyo.org/adservers/',
        'https://pgl.yoyo.org/adservers/',
        'https://pgl.yoyo.org/as/#about',
        'Unknown')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('6448c43b-b9ba-4629-bd61-8659840f4f38', 'source')
on conflict do nothing;


-- Fademind: Unchecky Ads
insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('eb752e59-9a69-4406-a120-dcaf054c3e4e',
        'Fademind: Unchecky Ads',
        'hosts',
        'https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts',
        'https://github.com/FadeMind/hosts.extras',
        'https://github.com/FadeMind/hosts.extras/issues',
        'https://github.com/FadeMind/hosts.extras/blob/master/COPYING',
        'MIT')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('eb752e59-9a69-4406-a120-dcaf054c3e4e', 'source')
on conflict do nothing;


-- Bigdargon: hostsVN
insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Bigdargon: hostsVN',
        'hosts',
        'https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts',
        'https://bigdargon.github.io/hostsVN/',
        'https://github.com/bigdargon/hostsVN/issues',
        'https://github.com/bigdargon/hostsVN/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Jdlingyu: Ad-wars',
        'hosts',
        'https://raw.githubusercontent.com/jdlingyu/ad-wars/master/hosts',
        'https://github.com/jdlingyu/ad-wars',
        'https://github.com/jdlingyu/ad-wars/issues',
        'https://github.com/jdlingyu/ad-wars',
        'Unknown')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Easylist: easyprivacy',
        'domain',
        'https://v.firebog.net/hosts/Easyprivacy.txt',
        'https://easylist.to/',
        'https://forums.lanik.us/',
        'http://creativecommons.org/licenses/by/3.0/',
        'Attribution 3.0 Unported')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Fabrice Prigent: Ads',
        'domain',
        'https://v.firebog.net/hosts/Prigent-Ads.txt',
        'https://dsi.ut-capitole.fr/blacklists/',
        'https://dsi.ut-capitole.fr/cgi-bin/squidguard_modify.cgi',
        'http://creativecommons.org/licenses/by-sa/4.0/',
        'Creative Commons Contract')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Quidsup: Trackers',
        'domain',
        'https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-blocklist.txt',
        'https://quidsup.net/notrack/blocklist.php',
        'https://quidsup.net/notrack/report.php',
        'https://www.gnu.org/licenses/gpl-3.0.en.html',
        'GNU General Public License v3.0')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Fademind: 2o7 Network Trackers',
        'hosts',
        'https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts',
        'https://github.com/FadeMind/hosts.extras',
        'https://github.com/FadeMind/hosts.extras/issues',
        'https://github.com/FadeMind/hosts.extras/blob/master/COPYING',
        'MIT')
on conflict do nothing;

insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('13caacd5-9a93-43eb-97c8-ed02cc70810a',
        'Crazy Max: WindowsSpyBlocker - Hosts spy rules',
        'hosts',
        'https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt',
        'https://github.com/crazy-max/WindowsSpyBlocker',
        'https://github.com/crazy-max/WindowsSpyBlocker/issues',
        'https://github.com/crazy-max/WindowsSpyBlocker/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('ceb9a000-f313-449c-9d68-367aabf50261',
        'Crazy Max: WindowsSpyBlocker - Hosts update rules',
        'hosts',
        'https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/update.txt',
        'https://github.com/crazy-max/WindowsSpyBlocker',
        'https://github.com/crazy-max/WindowsSpyBlocker/issues',
        'https://github.com/crazy-max/WindowsSpyBlocker/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('6635d010-0924-47fb-853c-30e32198000c',
        'Crazy Max: WindowsSpyBlocker - Hosts extra rules',
        'hosts',
        'https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/extra.txt',
        'https://github.com/crazy-max/WindowsSpyBlocker',
        'https://github.com/crazy-max/WindowsSpyBlocker/issues',
        'https://github.com/crazy-max/WindowsSpyBlocker/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Geoffrey Frogeye: First-Party Trackers',
        'hosts',
        'https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt',
        'https://geoffrey.frogeye.fr',
        'https://geoffrey.frogeye.fr',
        'https://git.frogeye.fr/geoffrey/eulaurarien/src/branch/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Geoffrey Frogeye: Multi-Party Trackers',
        'hosts',
        'https://hostfiles.frogeye.fr/multiparty-trackers-hosts.txt',
        'https://geoffrey.frogeye.fr',
        'https://geoffrey.frogeye.fr',
        'https://git.frogeye.fr/geoffrey/eulaurarien/src/branch/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Perflyst: Android Trackers',
        'domain',
        'https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/android-tracking.txt',
        'https://github.com/Perflyst/PiHoleBlocklist/',
        'https://github.com/Perflyst/PiHoleBlocklist/issues',
        'https://github.com/Perflyst/PiHoleBlocklist/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Perflyst: SmartTV Domains',
        'domain',
        'https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV.txt',
        'https://github.com/Perflyst/PiHoleBlocklist/',
        'https://github.com/Perflyst/PiHoleBlocklist/issues',
        'https://github.com/Perflyst/PiHoleBlocklist/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Perflyst: Amazon FireTV Domains',
        'domain',
        'https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/AmazonFireTV.txt',
        'https://github.com/Perflyst/PiHoleBlocklist/',
        'https://github.com/Perflyst/PiHoleBlocklist/issues',
        'https://github.com/Perflyst/PiHoleBlocklist/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('DandelionSprout: Anti Malware Filter',
        'hosts',
        'https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt',
        'https://github.com/DandelionSprout/adfilt',
        'https://github.com/DandelionSprout/adfilt/issues',
        'https://github.com/DandelionSprout/adfilt/blob/master/LICENSE.md',
        'Dandelicence')
on conflict do nothing;

insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('59073d0b-3882-49b0-98b2-a05ed6bf60f3',
        'DigitalSide: Threat-Intel',
        'domain',
        'https://raw.githubusercontent.com/davidonzo/Threat-Intel/master/lists/latestdomains.txt',
        'https://osint.digitalside.it/',
        'https://github.com/davidonzo/Threat-Intel/issues',
        'https://github.com/davidonzo/Threat-Intel/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Disconnect: Malvertising',
        'domain',
        'https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt',
        'https://disconnect.me',
        'https://disconnect.me/about',
        'https://www.gnu.org/licenses/gpl-3.0.en.html',
        'GPLv3')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Fabrice Prigent: Cryptojacking',
        'domain',
        'https://v.firebog.net/hosts/Prigent-Crypto.txt',
        'https://dsi.ut-capitole.fr/blacklists/',
        'https://dsi.ut-capitole.fr/cgi-bin/squidguard_modify.cgi',
        'http://creativecommons.org/licenses/by-sa/4.0/',
        'Creative Commons Contract')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('RiskAnalytics: Immortal Malware Domains',
        'domain',
        'https://mirror.cedia.org.ec/malwaredomains/immortal_domains.txt',
        'http://www.malwaredomains.com/',
        'http://www.malwaredomains.com/?page_id=13',
        'http://www.malwaredomains.com/?page_id=1508',
        'Noncommercial')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Malware Domain List',
        'hosts',
        'https://www.malwaredomainlist.com/hostslist/hosts.txt',
        'https://www.malwaredomainlist.com/',
        'https://www.malwaredomainlist.com/forums/',
        'https://www.malwaredomainlist.com/',
        'Can be used for free by anyone')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Mandiant APT1 Report',
        'domain',
        'https://bitbucket.org/ethanr/dns-blacklists/raw/8575c9f96e5b4a1308f2f12394abd86d0927a4a0/bad_lists/Mandiant_APT1_Report_Appendix_D.txt',
        'https://bitbucket.org/ethanr/dns-blacklists',
        'https://bitbucket.org/ethanr/dns-blacklists/issues?status=new&status=open',
        'https://bitbucket.org/ethanr/dns-blacklists',
        'Unknown')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Phishing Army: Extended Blocklist',
        'domain',
        'https://phishing.army/download/phishing_army_blocklist_extended.txt',
        'https://phishing.army/',
        'https://phishing.army/',
        'https://creativecommons.org/licenses/by-nc/4.0/',
        'Creative Commons Attribution-NonCommercial 4.0 International')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Quidsup: Malicious',
        'domain',
        'https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt',
        'https://quidsup.net/notrack/blocklist.php',
        'https://quidsup.net/notrack/report.php',
        'https://www.gnu.org/licenses/gpl-3.0.en.html',
        'GNU General Public License v3.0')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Shalla: Malicious',
        'domain',
        'https://v.firebog.net/hosts/Shalla-mal.txt',
        'http://www.shallalist.de/',
        'http://www.shallalist.de/',
        'http://www.shallalist.de/licence.html',
        'Shalla''s Blacklists - Licence')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Spam404',
        'domain',
        'https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt',
        'https://github.com/Spam404/lists',
        'https://github.com/Spam404/lists/issues',
        'https://github.com/Spam404/lists/blob/master/LICENSE.md/LICENSE.md',
        'Creative Commons Attribution-ShareAlike 4.0 International')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Fademind: Risky Hosts',
        'hosts',
        'https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts',
        'https://github.com/FadeMind/hosts.extras',
        'https://github.com/FadeMind/hosts.extras/issues',
        'https://github.com/FadeMind/hosts.extras/blob/master/COPYING',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('URLhaus: Malicious URL blocklist',
        'hosts',
        'https://urlhaus.abuse.ch/downloads/hostfile/',
        'https://urlhaus.abuse.ch/',
        'https://urlhaus.abuse.ch/browse/',
        'https://urlhaus.abuse.ch/api/#tos',
        'Creative Commons No Rights Reserved')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Fabrice Prigent: Malware',
        'domain',
        'https://v.firebog.net/hosts/Prigent-Malware.txt',
        'https://dsi.ut-capitole.fr/blacklists/',
        'https://dsi.ut-capitole.fr/cgi-bin/squidguard_modify.cgi',
        'http://creativecommons.org/licenses/by-sa/4.0/',
        'Creative Commons Contract')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('HorusTeknoloji: High Risk Phishing Blacklist',
        'domain',
        'https://raw.githubusercontent.com/HorusTeknoloji/TR-PhishingList/master/url-lists.txt',
        'https://github.com/HorusTeknoloji/TR-PhishingList',
        'https://github.com/HorusTeknoloji/TR-PhishingList/issues',
        'https://github.com/HorusTeknoloji/TR-PhishingList/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('ZeroDot1: CoinBlockerLists',
        'hosts',
        'https://zerodot1.gitlab.io/CoinBlockerLists/hosts_browser',
        'https://gitlab.com/ZeroDot1/CoinBlockerLists',
        'https://gitlab.com/ZeroDot1/CoinBlockerLists/-/issues',
        'https://gitlab.com/ZeroDot1/CoinBlockerLists/-/blob/master/LICENSE',
        'GNU Affero General Public License')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Chad Mayfield: Blocklist Porn All',
        'domain',
        'https://zerodot1.gitlab.io/CoinBlockerLists/hosts_browser',
        'https://gitlab.com/ZeroDot1/CoinBlockerLists',
        'https://gitlab.com/ZeroDot1/CoinBlockerLists/-/issues',
        'https://gitlab.com/ZeroDot1/CoinBlockerLists/-/blob/master/LICENSE',
        'GNU Affero General Public License')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Chad Mayfield: Blocklist Porn All',
        'domain',
        'https://raw.githubusercontent.com/chadmayfield/my-pihole-blocklists/master/lists/pi_blocklist_porn_all.list',
        'https://github.com/chadmayfield/my-pihole-blocklists',
        'https://github.com/chadmayfield/my-pihole-blocklists/issues',
        'https://github.com/chadmayfield/my-pihole-blocklists/blob/master/LICENSE',
        'GNU General Public License v3.0')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Chad Mayfield: Blocklist Porn Top 1Mil',
        'domain',
        'https://raw.githubusercontent.com/chadmayfield/my-pihole-blocklists/master/lists/pi_blocklist_porn_top1m.list',
        'https://github.com/chadmayfield/my-pihole-blocklists',
        'https://github.com/chadmayfield/my-pihole-blocklists/issues',
        'https://github.com/chadmayfield/my-pihole-blocklists/blob/master/LICENSE',
        'GNU General Public License v3.0')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Anudeep ND: Facebook',
        'hosts',
        'https://raw.githubusercontent.com/anudeepND/blacklist/master/facebook.txt',
        'https://github.com/anudeepND/blacklist',
        'https://github.com/anudeepND/blacklist/issues',
        'https://github.com/anudeepND/blacklist/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Anudeep ND: CoinMiner',
        'hosts',
        'https://raw.githubusercontent.com/anudeepND/blacklist/master/CoinMiner.txt',
        'https://github.com/anudeepND/blacklist',
        'https://github.com/anudeepND/blacklist/issues',
        'https://github.com/anudeepND/blacklist/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Steven Black Hosts: ad-hoc list',
        'hosts',
        'https://raw.githubusercontent.com/StevenBlack/hosts/master/data/StevenBlack/hosts',
        'http://stevenblack.com',
        'https://github.com/StevenBlack/hosts/issues',
        'https://github.com/StevenBlack/hosts/blob/master/license.txt',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Mitchell Krog: Badd Boyz Hosts',
        'hosts',
        'https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/hosts',
        'https://github.com/mitchellkrogza/Badd-Boyz-Hosts',
        'https://github.com/mitchellkrogza/Badd-Boyz-Hosts/issues',
        'https://github.com/mitchellkrogza/Badd-Boyz-Hosts/blob/master/LICENSE.md',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Tiuxo: ads',
        'hosts',
        'https://raw.githubusercontent.com/tiuxo/hosts/master/ads',
        'https://github.com/tiuxo/hosts',
        'https://github.com/tiuxo/hosts/issues',
        'https://github.com/tiuxo/hosts/blob/master/LICENSE',
        'Creative Commons Attribution 4.0 International')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Tiuxo: porn',
        'hosts',
        'https://raw.githubusercontent.com/tiuxo/hosts/master/porn',
        'https://github.com/tiuxo/hosts',
        'https://github.com/tiuxo/hosts/issues',
        'https://github.com/tiuxo/hosts/blob/master/LICENSE',
        'Creative Commons Attribution 4.0 International')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Sinfonietta: Pornography hosts',
        'hosts',
        'https://raw.githubusercontent.com/Sinfonietta/hostfiles/master/pornography-hosts',
        'https://github.com/Sinfonietta/hostfiles',
        'https://github.com/Sinfonietta/hostfiles/issues',
        'https://github.com/Sinfonietta/hostfiles/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Sinfonietta: Social media hosts',
        'hosts',
        'https://raw.githubusercontent.com/Sinfonietta/hostfiles/master/social-hosts',
        'https://github.com/Sinfonietta/hostfiles',
        'https://github.com/Sinfonietta/hostfiles/issues',
        'https://github.com/Sinfonietta/hostfiles/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Sinfonietta: Gambling Hosts',
        'hosts',
        'https://raw.githubusercontent.com/Sinfonietta/hostfiles/master/social-hosts',
        'https://github.com/Sinfonietta/hostfiles',
        'https://github.com/Sinfonietta/hostfiles/issues',
        'https://github.com/Sinfonietta/hostfiles/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Clefspeare13: Porn Hosts',
        'hosts',
        'https://raw.githubusercontent.com/Clefspeare13/pornhosts/master/0.0.0.0/hosts',
        'https://github.com/Clefspeare13/pornhosts',
        'https://github.com/Clefspeare13/pornhosts/issues',
        'https://github.com/Clefspeare13/pornhosts/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Marktron: fakenews',
        'hosts',
        'https://raw.githubusercontent.com/marktron/fakenews/master/fakenews',
        'https://github.com/marktron/fakenews',
        'https://github.com/marktron/fakenews/issues',
        'https://github.com/marktron/fakenews/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Cyber Threat Coalition: Vetted Domain',
        'domain',
        'https://blocklist.cyberthreatcoalition.org/vetted/domain.txt',
        'https://www.cyberthreatcoalition.org/',
        'https://www.cyberthreatcoalition.org/blocklist',
        'https://www.cyberthreatcoalition.org/about-us/code-of-conduct',
        'Creative Commons Attribution-ShareAlike 4.0 International')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Jerryn70: GoodbyeAds',
        'hosts',
        'https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Hosts/GoodbyeAds.txt',
        'https://github.com/jerryn70/GoodbyeAds',
        'https://github.com/jerryn70/GoodbyeAds/issues',
        'https://github.com/jerryn70/GoodbyeAds/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('EnergizedProtection: Spark',
        'domain',
        'https://block.energized.pro/spark/formats/domains.txt',
        'https://energized.pro/',
        'https://app.energized.pro/',
        'https://github.com/EnergizedProtection/block/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('EnergizedProtection: Blu',
        'domain',
        'https://block.energized.pro/blu/formats/domains.txt',
        'https://energized.pro/',
        'https://app.energized.pro/',
        'https://github.com/EnergizedProtection/block/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('EnergizedProtection: Blu GO',
        'domain',
        'https://block.energized.pro/bluGo/formats/domains.txt',
        'https://energized.pro/',
        'https://app.energized.pro/',
        'https://github.com/EnergizedProtection/block/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('EnergizedProtection: Basic',
        'domain',
        'https://block.energized.pro/basic/formats/domains.txt',
        'https://energized.pro/',
        'https://app.energized.pro/',
        'https://github.com/EnergizedProtection/block/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('EnergizedProtection: Porn',
        'domain',
        'https://block.energized.pro/porn/formats/domains.txt',
        'https://energized.pro/',
        'https://app.energized.pro/',
        'https://github.com/EnergizedProtection/block/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('EnergizedProtection: Ultimate',
        'domain',
        'https://block.energized.pro/ultimate/formats/domains.txt',
        'https://energized.pro/',
        'https://app.energized.pro/',
        'https://github.com/EnergizedProtection/block/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('EnergizedProtection: Unified',
        'domain',
        'https://block.energized.pro/unified/formats/domains.txt',
        'https://energized.pro/',
        'https://app.energized.pro/',
        'https://github.com/EnergizedProtection/block/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('EnergizedProtection: Xtreme',
        'domain',
        'https://block.energized.pro/extensions/xtreme/formats/domains.txt',
        'https://energized.pro/',
        'https://app.energized.pro/',
        'https://github.com/EnergizedProtection/block/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('EnergizedProtection: Regional',
        'domain',
        'https://block.energized.pro/extensions/regional/formats/domains.txt',
        'https://energized.pro/',
        'https://app.energized.pro/',
        'https://github.com/EnergizedProtection/block/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('EnergizedProtection: Social',
        'domain',
        'https://block.energized.pro/extensions/social/formats/domains.txt',
        'https://energized.pro/',
        'https://app.energized.pro/',
        'https://github.com/EnergizedProtection/block/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('EnergizedProtection: Porn Lite',
        'domain',
        'https://block.energized.pro/extensions/porn-lite/formats/domains.txt',
        'https://energized.pro/',
        'https://app.energized.pro/',
        'https://github.com/EnergizedProtection/block/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Paulgb: BarbBlock Domain List',
        'domain',
        'https://paulgb.github.io/BarbBlock/blacklists/domain-list.txt',
        'https://github.com/paulgb/BarbBlock',
        'https://github.com/paulgb/BarbBlock/issues',
        'https://github.com/paulgb/BarbBlock/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('AZORult Tracker: Domain List',
        'domain',
        'https://azorult-tracker.net/api/list/domain?format=plain',
        'https://azorult-tracker.net/',
        'https://azorult-tracker.net/about',
        'https://en.wikipedia.org/wiki/Open_Database_License',
        'Open Database License')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('280blocker: Domain List',
        'domain',
        'https://280blocker.net/files/280blocker_domain.txt',
        'https://280blocker.net',
        'https://280blocker.net/checkblock/',
        'https://creativecommons.org/licenses/by-nc-nd/4.0/',
        'Attribution-NonCommercial-NoDerivatives 4.0 International')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Block List Project: Ads',
        'hosts',
        'https://blocklistproject.github.io/Lists/ads.txt',
        'https://blocklist.site',
        'https://github.com/blocklistproject/lists/issues',
        'https://github.com/blocklistproject/Lists/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Block List Project: Tracking',
        'hosts',
        'https://blocklistproject.github.io/Lists/tracking.txt',
        'https://blocklist.site',
        'https://github.com/blocklistproject/lists/issues',
        'https://github.com/blocklistproject/Lists/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Block List Project: Malware',
        'hosts',
        'https://blocklistproject.github.io/Lists/malware.txt',
        'https://blocklist.site',
        'https://github.com/blocklistproject/lists/issues',
        'https://github.com/blocklistproject/Lists/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Block List Project: Phishing',
        'hosts',
        'https://blocklistproject.github.io/Lists/phishing.txt',
        'https://blocklist.site',
        'https://github.com/blocklistproject/lists/issues',
        'https://github.com/blocklistproject/Lists/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Block List Project: Gambling',
        'hosts',
        'https://blocklistproject.github.io/Lists/gambling.txt',
        'https://blocklist.site',
        'https://github.com/blocklistproject/lists/issues',
        'https://github.com/blocklistproject/Lists/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Block List Project: Facebook',
        'hosts',
        'https://blocklistproject.github.io/Lists/facebook.txt',
        'https://blocklist.site',
        'https://github.com/blocklistproject/lists/issues',
        'https://github.com/blocklistproject/Lists/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Block List Project: Abuse',
        'hosts',
        'https://blocklistproject.github.io/Lists/abuse.txt',
        'https://blocklist.site',
        'https://github.com/blocklistproject/lists/issues',
        'https://github.com/blocklistproject/Lists/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Block List Project: Crypto',
        'hosts',
        'https://blocklistproject.github.io/Lists/crypto.txt',
        'https://blocklist.site',
        'https://github.com/blocklistproject/lists/issues',
        'https://github.com/blocklistproject/Lists/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Block List Project: Drugs',
        'hosts',
        'https://blocklistproject.github.io/Lists/drugs.txt',
        'https://blocklist.site',
        'https://github.com/blocklistproject/lists/issues',
        'https://github.com/blocklistproject/Lists/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Block List Project: Fraud',
        'hosts',
        'https://blocklistproject.github.io/Lists/fraud.txt',
        'https://blocklist.site',
        'https://github.com/blocklistproject/lists/issues',
        'https://github.com/blocklistproject/Lists/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Block List Project: Piracy',
        'hosts',
        'https://blocklistproject.github.io/Lists/piracy.txt',
        'https://blocklist.site',
        'https://github.com/blocklistproject/lists/issues',
        'https://github.com/blocklistproject/Lists/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Block List Project: Porn',
        'hosts',
        'https://blocklistproject.github.io/Lists/porn.txt',
        'https://blocklist.site',
        'https://github.com/blocklistproject/lists/issues',
        'https://github.com/blocklistproject/Lists/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Block List Project: Ransomware',
        'hosts',
        'https://blocklistproject.github.io/Lists/ransomware.txt',
        'https://blocklist.site',
        'https://github.com/blocklistproject/lists/issues',
        'https://github.com/blocklistproject/Lists/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Block List Project: Redirect',
        'hosts',
        'https://blocklistproject.github.io/Lists/redirect.txt',
        'https://blocklist.site',
        'https://github.com/blocklistproject/lists/issues',
        'https://github.com/blocklistproject/Lists/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Block List Project: Scam',
        'hosts',
        'https://blocklistproject.github.io/Lists/scam.txt',
        'https://blocklist.site',
        'https://github.com/blocklistproject/lists/issues',
        'https://github.com/blocklistproject/Lists/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Block List Project: Torrent',
        'hosts',
        'https://blocklistproject.github.io/Lists/torrent.txt',
        'https://blocklist.site',
        'https://github.com/blocklistproject/lists/issues',
        'https://github.com/blocklistproject/Lists/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Block List Project: Youtube',
        'hosts',
        'https://blocklistproject.github.io/Lists/youtube.txt',
        'https://blocklist.site',
        'https://github.com/blocklistproject/lists/issues',
        'https://github.com/blocklistproject/Lists/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('hBlock: Hosts Domains',
        'domain',
        'https://hblock.molinero.dev/hosts_domains.txt',
        'https://hblock.molinero.dev/',
        'https://github.com/hectorm/hblock/issues',
        'https://github.com/hectorm/hblock/blob/master/LICENSE.md',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Disconnect: Tracking',
        'domain',
        'https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt',
        'https://disconnect.me',
        'https://disconnect.me/about',
        'https://www.gnu.org/licenses/gpl-3.0.en.html',
        'GPLv3')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Yhonay: Anti popads.net',
        'hosts',
        'https://raw.githubusercontent.com/Yhonay/antipopads/master/hosts',
        'https://github.com/Yhonay/antipopads',
        'https://github.com/Yhonay/antipopads/issues',
        'https://github.com/Yhonay/antipopads/blob/master/LICENSE',
        'Do What The F*ck You Want To Public License')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Infinitytec: Ads and trackers',
        'hosts',
        'https://raw.githubusercontent.com/infinitytec/blocklists/master/ads-and-trackers.txt',
        'https://github.com/infinitytec/blocklists',
        'https://github.com/infinitytec/blocklists/issues',
        'https://github.com/infinitytec/blocklists/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Infinitytec: Scams and phishing',
        'hosts',
        'https://raw.githubusercontent.com/infinitytec/blocklists/master/scams-and-phishing.txt',
        'https://github.com/infinitytec/blocklists',
        'https://github.com/infinitytec/blocklists/issues',
        'https://github.com/infinitytec/blocklists/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Infinitytec: Medical Pseudoscience',
        'hosts',
        'https://raw.githubusercontent.com/infinitytec/blocklists/master/medicalpseudoscience.txt',
        'https://github.com/infinitytec/blocklists',
        'https://github.com/infinitytec/blocklists/issues',
        'https://github.com/infinitytec/blocklists/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('Infinitytec: Possibilities',
        'hosts',
        'https://raw.githubusercontent.com/infinitytec/blocklists/master/possibilities.txt',
        'https://github.com/infinitytec/blocklists',
        'https://github.com/infinitytec/blocklists/issues',
        'https://github.com/infinitytec/blocklists/blob/master/LICENSE',
        'MIT')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('KriskIntel: Malicious Domains',
        'domain',
        'https://kriskintel.com/feeds/ktip_malicious_domains.txt',
        'https://kriskintel.com/',
        'https://kriskintel.com/',
        'https://kriskintel.com/',
        'Creative Commons Attribution 4.0 International')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('KriskIntel: Covid-19 Phishing Feed',
        'domain',
        'https://kriskintel.com/feeds/ktip_covid_domains.txt',
        'https://kriskintel.com/',
        'https://kriskintel.com/',
        'https://kriskintel.com/',
        'Creative Commons Attribution 4.0 International')
on conflict do nothing;

insert into blocklist(name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('KriskIntel: Ransomware Feeds',
        'domain',
        'https://kriskintel.com/feeds/ktip_ransomware_feeds.txt',
        'https://kriskintel.com/',
        'https://kriskintel.com/',
        'https://kriskintel.com/',
        'Creative Commons Attribution 4.0 International')
on conflict do nothing;

insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('5b94b549-1f07-4229-bd65-cfb8b64e8343',
        'Bjornstar: Hosts',
        'hosts',
        'https://raw.githubusercontent.com/bjornstar/hosts/master/hosts',
        'https://github.com/bjornstar/hosts',
        'https://github.com/bjornstar/hosts/issues',
        'https://github.com/bjornstar/hosts/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('5b94b549-1f07-4229-bd65-cfb8b64e8343', 'source')
on conflict do nothing;

insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('4d520159-b3a9-41ad-b414-67c8356fe50d',
        'Stamparm: Blackbook',
        'domain',
        'https://raw.githubusercontent.com/stamparm/blackbook/master/blackbook.txt',
        'https://github.com/stamparm/blackbook',
        'https://github.com/stamparm/blackbook/issues',
        'https://github.com/stamparm/blackbook',
        'Unknown')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('4d520159-b3a9-41ad-b414-67c8356fe50d', 'source')
on conflict do nothing;


insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('6aca4c7d-0d96-4c62-8e3d-7d0aa8f644f0',
        'Yous: YousList',
        'hosts',
        'https://raw.githubusercontent.com/yous/YousList/master/hosts.txt',
        'https://github.com/yous/YousList',
        'https://github.com/yous/YousList/issues',
        'https://github.com/yous/YousList#license',
        'Creative Commons Attribution 4.0 International')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('6aca4c7d-0d96-4c62-8e3d-7d0aa8f644f0', 'source')
on conflict do nothing;

insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('2b6e809a-6694-4bd7-9267-8a6289518fbe',
        'PingLin Li: Ad hosts',
        'hosts',
        'https://raw.githubusercontent.com/ilpl/ad-hosts/master/hosts',
        'https://github.com/ilpl/ad-hosts',
        'https://github.com/ilpl/ad-hosts/issues',
        'https://github.com/ilpl/ad-hosts/blob/master/LICENSE',
        'GNU General Public License v3.0')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('2b6e809a-6694-4bd7-9267-8a6289518fbe', 'source')
on conflict do nothing;


insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('99e739aa-1ec4-4384-890d-eea9c1980ab9',
        'Socram: Not on my shift!',
        'domain',
        'https://orca.pet/notonmyshift/domains.txt',
        'https://orca.pet/notonmyshift/',
        'https://github.com/socram8888/not-on-my-shift/issues',
        'https://orca.pet/#license',
        'ISC license')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('99e739aa-1ec4-4384-890d-eea9c1980ab9', 'source')
on conflict do nothing;

insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('18d6705c-0634-4b87-88dd-583ea0c5cabd',
        'Socram: Not on my shift!',
        'domain',
        'https://orca.pet/notonmyshift/domains.txt',
        'https://orca.pet/notonmyshift/',
        'https://github.com/socram8888/not-on-my-shift/issues',
        'https://orca.pet/#license',
        'ISC license')
on conflict do nothing;

insert into list_tag(blocklist_id, value)
values ('99e739aa-1ec4-4384-890d-eea9c1980ab9', 'source')
on conflict do nothing;

insert into blocklist(id, name, format, download_url, homepage_url, issues_url, license_url, license_type)
values ('b2d7e298-3e9b-4fff-a769-2e7dfc23f4b0',
        'The Quantum Alpha: The_Quantum_Ad-List.txt',
        'hosts',
        'https://gitlab.com/The_Quantum_Alpha/the-quantum-ad-list/-/raw/master/For%20hosts%20file/The_Quantum_Ad-List.txt',
        'https://gitlab.com/The_Quantum_Alpha/the-quantum-ad-list',
        'https://gitlab.com/The_Quantum_Alpha/the-quantum-ad-list/-/issues',
        'https://gitlab.com/The_Quantum_Alpha/the-quantum-ad-list/-/blob/master/LICENSE',
        'Unlicense')
on conflict do nothing;