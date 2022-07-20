SELECT ROW_NUMBER() OVER (
        ORDER BY COUNT(email_domain) DESC
    ) row_num,
    email_domain,
    COUNT(email_domain) AS num_users
    FROM users GROUP BY email_domain ORDER BY COUNT(email_domain) DESC LIMIT 25;

SELECT COUNT(*) AS new_york_learners FROM users WHERE city='New York';

SELECT COUNT(*) AS num_mobile_users FROM users WHERE mobile_app='mobile-user';

SELECT DATE_FORMAT(sign_up_at, '%H') AS hour, COUNT(DATE_FORMAT(sign_up_at, '%H'))
AS num_sign_ups FROM users GROUP BY hour ORDER BY hour ASC;

CREATE VIEW cpp_learners AS SELECT email_domain, COUNT(learn_cpp) AS cpp FROM users
JOIN progress USING (user_id) WHERE learn_cpp IN ("started", "completed") GROUP BY
email_domain;
CREATE VIEW sql_learners AS SELECT email_domain, COUNT(learn_sql) AS `sql` FROM
users JOIN progress USING (user_id) WHERE learn_sql IN ("started", "completed")
GROUP BY email_domain;
CREATE VIEW html_learners AS SELECT email_domain, COUNT(learn_html) AS html FROM
users JOIN progress USING (user_id) WHERE learn_html IN ("started", "completed")
GROUP BY email_domain;
CREATE VIEW javascript_learners AS SELECT email_domain, COUNT(learn_javascript) AS
javascript FROM users JOIN progress USING (user_id) WHERE learn_javascript IN
("started", "completed") GROUP BY email_domain;
CREATE VIEW java_learners AS SELECT email_domain, COUNT(learn_java) AS java FROM
users JOIN progress USING (user_id) WHERE learn_java IN ("started", "completed")
GROUP BY email_domain;
SELECT DISTINCT email_domain, cpp_learners.cpp, sql_learners.`sql`,
html_learners.html, javascript_learners.javascript, java_learners.java,
    @var_most_popular_num:=GREATEST(COALESCE(cpp_learners.cpp, 0),
COALESCE(sql_learners.`sql`, 0), COALESCE(html_learners.html, 0),
COALESCE(javascript_learners.javascript, 0), COALESCE(java_learners.java,0)) AS
most_popular_num,
    CASE @var_most_popular_num
        WHEN cpp THEN 'cpp'
        WHEN `sql` THEN 'sql'
        WHEN html THEN 'html'
        WHEN javascript THEN 'javascript'
        WHEN java THEN 'java'
        END AS most_popular_course
    FROM users LEFT JOIN cpp_learners USING (email_domain)
    JOIN sql_learners USING (email_domain)
    JOIN html_learners USING (email_domain)
    JOIN javascript_learners USING (email_domain)
    JOIN java_learners USING (email_domain)
    ORDER BY email_domain ASC;

SELECT SUM(CASE WHEN learn_cpp IN ("started", "completed") THEN 1 ELSE 0 END) AS
cpp,
    SUM(CASE WHEN learn_sql IN ("started", "completed") THEN 1 ELSE 0 END) AS
`sql`,
    SUM(CASE WHEN learn_html IN ("started", "completed") THEN 1 ELSE 0 END) AS html,
    SUM(CASE WHEN learn_javascript IN ("started", "completed") THEN 1 ELSE 0 END) AS
javascript,
    SUM(CASE WHEN learn_java IN ("started", "completed") THEN 1 ELSE 0 END) AS java,
    COUNT(*) AS total
    FROM users JOIN progress USING(user_id) WHERE city="New York";

SELECT * FROM users JOIN progress USING(user_id) WHERE city="Chicago";SELECT
SUM(CASE WHEN learn_cpp IN ("started", "completed")THEN 1 ELSE 0 END) AS cpp,
    SUM(CASE WHEN learn_sql IN ("started", "completed") THEN 1 ELSE 0 END) AS
`sql`,
    SUM(CASE WHEN learn_html IN ("started", "completed") THEN 1 ELSE 0 END) AS html,
    SUM(CASE WHEN learn_javascript IN ("started", "completed") THEN 1 ELSE 0 END) AS
javascript,
    SUM(CASE WHEN learn_java IN ("started", "completed") THEN 1 ELSE 0 END) AS java,
    COUNT(*) AS total
    FROM users JOIN progress USING(user_id) WHERE city="Chicago";