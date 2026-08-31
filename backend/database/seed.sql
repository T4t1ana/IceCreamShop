--Roles Obligatorios
INSERT INTO roles(id, name) VALUES
(1, 'admin'),
(2, 'employee'),
(3, 'client')
ON CONFLICT (id) DO NOTHING;

SELECT SETVAL('roles_id_seq', (SELECT MAX(id) FROM roles));

--SEDES FÍSICAS INICIALES
INSERT INTO branches (name, adress, phone) VALUES
('Sede C.C Viva Envigado', 'Cra. 48 32b Sur-139, Envigado, Antioquia 055422', '+57 3492495293'),
('Sede P.C El Tesoro', 'Carrera 29 #3 9, Medellín', '+57 3928427423');

--CATEGORÍAS DEL CATÁLOGO
INSERT INTO categories (name, description) VALUES
('Cones & Cups', 'Barquillos artesanales crocantes y vasos biodegradables'),
('Flavors', 'Sabores artesanales preparados diariamente para tus bolas de helado'),
('Toppings', 'Golosinas, frutos secos y adiciones para acompañar tu helado'),
('Milkshakes', 'Batidos cremosos preparados a base de helado y leche entera o vegetal'),
('Specialties', 'Creaciones de la casa, copas gigantes y combinaciones exclusivas');

--PRODUCTOS
INSERT INTO products (categorie_id, name, description, price, image_URL, is_available) VALUES
--Sabores
(2, 'Vainilla Bourbon', 'Helado de vainilla natural de Madagascar', 3500.00, 'https://images.unsplash.com/photo-1570197788417-0e82375c9371?w=500', true),
(2, 'Chocolate Belga 70%', 'Helado intenso de chocolate negro', 4000.00, 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=500', true),
(2, 'Fresa Silvestre', 'Helado artesanal a base de fresas frescas maceradas', 3500.00, 'https://images.unsplash.com/photo-1497034825429-c343d7c6a68f?w=500', true),
(2, 'Arequipe & Galleta', 'Helado de dulce de leche con trozos de galleta crocante', 3800.00, 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=500', true),

--Toppings
(3, 'Chispas de Chocolate', 'Lluvia de chocolate semi-amargo', 1500.00, 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=500', true),
(3, 'Maní Tostado', 'Trozos de maní crocante ligeramente salado', 1200.00, 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=500', true),
(3, 'Salsa de Frutos Rojos', 'Mermelada artesanal de mora, fresa y arándanos', 2000.00, 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=500', true),

-- Especialidades y Batidos (Categorías 4 y 5)
(4, 'Oreo Monster Shake', 'Malteada de helado de vainilla triturado con galletas Oreo', 14000.00, 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=500', true),
(5, 'Banana Split Real', 'Tres bolas de helado a elección, banano, crema batida y cereza', 18500.00, 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=500', true);