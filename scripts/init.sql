-- 1. Extensiones
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Tablas
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(150) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    alias VARCHAR(50) UNIQUE NOT NULL,
    birth_date DATE NOT NULL
);

CREATE TABLE posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE likes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_user_post_like UNIQUE (user_id, post_id)
);

-- 3. Datos de prueba
INSERT INTO users (email, password) 
VALUES ('usuario@ejemplo.com', '$2a$10$8K1p/a0dxclDEu8bg5.S9eHqX.S8f0.9.3.9.3.9.3.9.3.9.3');

INSERT INTO profiles (user_id, first_name, last_name, alias, birth_date)
VALUES (
    (SELECT id FROM users WHERE email = 'usuario@ejemplo.com'),
    'Juan', 'Pérez', 'juan_viajero', '1995-05-15'
);

INSERT INTO posts (user_id, message) VALUES 
((SELECT id FROM users WHERE email = 'usuario@ejemplo.com'), '¡Hola mundo! Iniciando mi aventura en esta red social.'),
((SELECT id FROM users WHERE email = 'usuario@ejemplo.com'), 'Conociendo el mundo: hoy visité las montañas, el aire es increíble.'),
((SELECT id FROM users WHERE email = 'usuario@ejemplo.com'), 'Probando la comida local, ¡es lo mejor de viajar!');

INSERT INTO likes (user_id, post_id)
VALUES (
    (SELECT id FROM users WHERE email = 'usuario@ejemplo.com'),
    (SELECT id FROM posts WHERE message LIKE '%Conociendo el mundo%' LIMIT 1)
);