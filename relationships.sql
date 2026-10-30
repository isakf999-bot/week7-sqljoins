DROP TABLE IF EXISTS profiles, users, books, authors, student_courses, students, courses;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username TEXT NOT NULL
);

CREATE TABLE profiles (
  id SERIAL PRIMARY KEY,
  user_id INT UNIQUE REFERENCES users(id),
  bio TEXT
);

INSERT INTO users (username) VALUES ('isak'), ('anna');
INSERT INTO profiles (user_id, bio) VALUES (1, 'Gillar fotboll'), (2, 'Gillar musik');

SELECT u.username, p.bio
FROM users u
JOIN profiles p ON u.id = p.user_id;


CREATE TABLE authors (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE books (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  author_id INT REFERENCES authors(id)
);

INSERT INTO authors (name) VALUES ('Astrid Lindgren'), ('J.K. Rowling');
INSERT INTO books (title, author_id) VALUES
  ('Pippi Långstrump', 1),
  ('Emil i Lönneberga', 1),
  ('Harry Potter', 2);

SELECT a.name, b.title
FROM authors a
JOIN books b ON a.id = b.author_id;


CREATE TABLE students (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE courses (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL
);

CREATE TABLE student_courses (
  student_id INT REFERENCES students(id),
  course_id INT REFERENCES courses(id),
  PRIMARY KEY (student_id, course_id)
);

INSERT INTO students (name) VALUES ('Isak'), ('Anna'), ('Erik');
INSERT INTO courses (title) VALUES ('SQL'), ('JavaScript');
INSERT INTO student_courses (student_id, course_id) VALUES (1, 1), (1, 2), (2, 1), (3, 2);

SELECT s.name, c.title
FROM students s
JOIN student_courses sc ON s.id = sc.student_id
JOIN courses c ON c.id = sc.course_id;

-- Try to break it
-- INSERT INTO books (title, author_id) VALUES ('Test', 99);
-- Fel: ERROR:  insert or update on table "student_courses" violates foreign key constraint "student_courses_student_id_fkey"
-- Det blir fel för att det inte finns någon author med id 99.

-- INSERT INTO student_courses VALUES (1, 1);
-- Fel: ERROR:  duplicate key value violates unique constraint "student_courses_pkey"
-- Key (student_id, course_id)=(1, 1) already exists. 
-- Det blir fel för att student 1 redan går kurs 1, och primary key får inte ha dubbletter.
