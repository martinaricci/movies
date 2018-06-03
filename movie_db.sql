CREATE DATABASE movie_db;

-- \c movie_db

CREATE TABLE movies (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(50),
  year VARCHAR(50),
  poster VARCHAR(300),
  plot VARCHAR(800) NOT NULL
);

-- connettere l'applicazione a un database
-- ogni volta che prendo le info nell'api le voglio inserire nel mio database cosi ce le ho gia'

-- INSERT INTO movies (id, name, year, poster, plot)