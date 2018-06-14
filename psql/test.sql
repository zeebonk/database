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
