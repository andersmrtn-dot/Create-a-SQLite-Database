-- ============================================================
--  Library Database — Books, Authors, Quotes
--  Compatible with SQLite 3 and standard SQL databases
-- ============================================================


-- ------------------------------------------------------------
--  Schema
-- ------------------------------------------------------------

CREATE TABLE Authors (
  author_id   INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT    NOT NULL,
  birth_year  INTEGER,
  nationality TEXT
);

CREATE TABLE Books (
  book_id     INTEGER PRIMARY KEY AUTOINCREMENT,
  title       TEXT    NOT NULL,
  author_id   INTEGER REFERENCES Authors(author_id),
  genre       TEXT,
  year        INTEGER
);

CREATE TABLE Quotes (
  quote_id    INTEGER PRIMARY KEY AUTOINCREMENT,
  quote_text  TEXT    NOT NULL,
  book_id     INTEGER REFERENCES Books(book_id),
  author_id   INTEGER REFERENCES Authors(author_id)
);


-- ------------------------------------------------------------
--  Authors (5 rows)
-- ------------------------------------------------------------

INSERT INTO Authors (name, birth_year, nationality) VALUES
  ('George Orwell',          1903, 'British'),
  ('Toni Morrison',          1931, 'American'),
  ('Gabriel García Márquez', 1927, 'Colombian'),
  ('Ursula K. Le Guin',      1929, 'American'),
  ('Fyodor Dostoevsky',      1821, 'Russian');


-- ------------------------------------------------------------
--  Books (10 rows)
-- ------------------------------------------------------------

INSERT INTO Books (title, author_id, genre, year) VALUES
  ('Nineteen Eighty-Four',          1, 'Dystopian',        1949),
  ('Animal Farm',                   1, 'Satire',           1945),
  ('Beloved',                       2, 'Literary',         1987),
  ('Song of Solomon',               2, 'Literary',         1977),
  ('One Hundred Years of Solitude', 3, 'Magical Realism',  1967),
  ('Love in the Time of Cholera',   3, 'Romance',          1985),
  ('The Left Hand of Darkness',     4, 'Science Fiction',  1969),
  ('The Dispossessed',              4, 'Science Fiction',  1974),
  ('Crime and Punishment',          5, 'Literary',         1866),
  ('The Brothers Karamazov',        5, 'Literary',         1880);


-- ------------------------------------------------------------
--  Quotes (20 rows)
-- ------------------------------------------------------------

INSERT INTO Quotes (quote_text, book_id, author_id) VALUES
  ('War is peace. Freedom is slavery. Ignorance is strength.', 1, 1),
  ('Big Brother is watching you.', 1, 1),
  ('In a time of deceit telling the truth is a revolutionary act.', NULL, 1),
  ('Who controls the past controls the future.', 1, 1),
  ('All animals are equal, but some animals are more equal than others.', 2, 1),
  ('Man serves the interests of no creature except himself.', 2, 1),
  ('124 was spiteful. Full of a baby''s venom.', 3, 2),
  ('Definitions belong to the definers, not the defined.', 3, 2),
  ('If you have some power, then your job is to empower somebody else.', NULL, 2),
  ('There is no greater agony than bearing an untold story inside you.', NULL, 2),
  ('It''s enough for me to be sure that you and I exist at this moment.', 5, 3),
  ('A person doesn''t die when he should, but when he can.', 6, 3),
  ('The secret of a good old age is simply an honorable pact with solitude.', 5, 3),
  ('There is always something left to love.', 6, 3),
  ('The only thing that makes life possible is permanent, intolerable uncertainty.', 7, 4),
  ('It is good to have an end to journey toward, but it is the journey that matters.', 7, 4),
  ('True journey is return.', 7, 4),
  ('Pain is a lesser thing than pleasure, a narrower world.', 8, 4),
  ('Pain and suffering are always inevitable for a large intelligence.', 9, 5),
  ('Beauty will save the world.', 10, 5);


-- ============================================================
--  Queries
-- ============================================================

-- 1. All books with their author
SELECT b.title, a.name AS author, b.genre, b.year
FROM Books b
JOIN Authors a ON b.author_id = a.author_id
ORDER BY b.year;

-- 2. Number of books per author
SELECT a.name, COUNT(b.book_id) AS book_count
FROM Authors a
LEFT JOIN Books b ON a.author_id = b.author_id
GROUP BY a.author_id
ORDER BY book_count DESC;

-- 3. Number of quotes per author
SELECT a.name, COUNT(q.quote_id) AS quote_count
FROM Authors a
LEFT JOIN Quotes q ON a.author_id = q.author_id
GROUP BY a.author_id
ORDER BY quote_count DESC;

-- 4. Quotes tied to a specific book
SELECT b.title, q.quote_text
FROM Quotes q
JOIN Books b ON q.book_id = b.book_id
WHERE b.title = 'Nineteen Eighty-Four';

-- 5. Authors whose quotes are not tied to a book
SELECT DISTINCT a.name, q.quote_text
FROM Quotes q
JOIN Authors a ON q.author_id = a.author_id
WHERE q.book_id IS NULL;

-- 6. All science fiction books with at least one quote
SELECT DISTINCT b.title, a.name AS author
FROM Books b
JOIN Authors a ON b.author_id = a.author_id
JOIN Quotes q ON q.book_id = b.book_id
WHERE b.genre = 'Science Fiction';

-- 7. Most quoted book
SELECT b.title, COUNT(q.quote_id) AS quotes
FROM Books b
JOIN Quotes q ON q.book_id = b.book_id
GROUP BY b.book_id
ORDER BY quotes DESC
LIMIT 1;

-- 8. Authors born before 1900 and their books
SELECT a.name, a.birth_year, b.title
FROM Authors a
JOIN Books b ON b.author_id = a.author_id
WHERE a.birth_year < 1900
ORDER BY a.birth_year;

-- 9. Full catalogue: author + book + quotes
SELECT a.name AS author, b.title, q.quote_text
FROM Authors a
JOIN Books b ON b.author_id = a.author_id
LEFT JOIN Quotes q ON q.book_id = b.book_id
ORDER BY a.name, b.title;

-- 10. Search quotes by keyword
SELECT q.quote_text, a.name AS author, b.title
FROM Quotes q
JOIN Authors a ON q.author_id = a.author_id
LEFT JOIN Books b ON q.book_id = b.book_id
WHERE q.quote_text LIKE '%truth%';
