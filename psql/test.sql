SELECT '';
SELECT '';

SELECT 'Search for "microservices":';
SELECT * FROM search_services('microservices');
SELECT '(should be a row above this)';
-- Assert
SELECT 1/count(*) FROM search_services('microservices');
SELECT '';
SELECT '';

SELECT 'Search for "microse":';
SELECT * FROM search_services('microse');
SELECT '(should be a row above this)';
-- Assert
SELECT 1/count(*) FROM search_services('microse');
SELECT '';
SELECT '';

SELECT 'Search for "database microse":';
SELECT * FROM search_services('database microse');
SELECT '(should be a row above this)';
-- Assert
SELECT 1/count(*) FROM search_services('database microse');
SELECT '';
SELECT '';

SELECT 'Search for "bananas":';
SELECT * FROM search_services('bananas');
-- Assert
SELECT 1/(case when count(*) = 0 then 1 else 0 end) FROM search_services('bananas');
SELECT '';
SELECT '';

SELECT 'Search for "database bana":';
SELECT * FROM search_services('database bana');
-- Assert
SELECT 1/(case when count(*) = 0 then 1 else 0 end) FROM search_services('database bana');
SELECT '';
SELECT '';

insert into organizations(uuid, name) values ('20B199EA-5F50-41D8-8D03-C126A3E8F19C', 'A');
insert into owners(uuid, service, service_id, username) values ('EB0C25D8-5B5A-43F6-81B4-1A3880243C96', 'github', '123', 'U_1');
insert into repos(uuid, owner_uuid, service, service_id, name) values ('2E2586E2-D2D7-4E6F-B10E-62C89CC47D51', 'EB0C25D8-5B5A-43F6-81B4-1A3880243C96', 'github', '999', 'A-a');
insert into apps(uuid, organization_uuid, repo_uuid, name, timestamp) values ('E9E97287-3AAC-44DF-A5E0-67AA42F00429', '20B199EA-5F50-41D8-8D03-C126A3E8F19C', '2E2586E2-D2D7-4E6F-B10E-62C89CC47D51', 'A-a-1', now());
insert into releases(app_uuid, message, owner_uuid, timestamp, payload) values ('E9E97287-3AAC-44DF-A5E0-67AA42F00429', 'Blah 1', 'EB0C25D8-5B5A-43F6-81B4-1A3880243C96', now(), jsonb_build_object());
insert into releases(app_uuid, message, owner_uuid, timestamp, payload) values ('E9E97287-3AAC-44DF-A5E0-67AA42F00429', 'Blah 1', 'EB0C25D8-5B5A-43F6-81B4-1A3880243C96', now(), jsonb_build_object());
insert into releases(app_uuid, message, owner_uuid, timestamp, payload) values ('E9E97287-3AAC-44DF-A5E0-67AA42F00429', 'Blah 1', 'EB0C25D8-5B5A-43F6-81B4-1A3880243C96', now(), jsonb_build_object());

insert into tokens(uuid, owner_uuid, type, name) VALUES ('901A9BC2-5FD6-4A42-B54A-BD9242D8DE5C', 'EB0C25D8-5B5A-43F6-81B4-1A3880243C96', 'API', 'Test API Token');
update token_secrets set secret = 'c2poZGYwOXcwZWZmMGRnaGY=' WHERE token_uuid = '901A9BC2-5FD6-4A42-B54A-BD9242D8DE5C';
