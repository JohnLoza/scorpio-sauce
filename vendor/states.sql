/*
 * $ cat file.sql | heroku pg:psql --app app_`name`
 * $ echo "select * from table," | heroku pg:psql --app app_`name`
 * $ heroku pg:psql --app app_`name` < file.sql
 */

/* states */
INSERT INTO states (id, `name`) VALUES
('2526','Aguascalientes'),
('2528','Baja California Sur'),
('2527','Baja California'),
('2529','Campeche'),
('2530','Chihuahua'),
('2531','Chiapas'),
('2532','Coahuila'),
('2533','Colima'),
('2534','Ciudad de México'),
('2535','Durango'),
('2536','Guerrero'),
('2537','Guanajuato'),
('2538','Hidalgo'),
('2539','Jalisco'),
('2540','Edo. México'),
('2541','Michoacán'),
('2542','Morelos'),
('2543','Nayarit'),
('2544','Nuevo León'),
('2545','Oaxaca'),
('2546','Puebla'),
('2547','Querétaro'),
('2548','Quintana Roo'),
('2549','Sinaloa'),
('2550','San Luis Potosí'),
('2551','Sonora'),
('2552','Tabasco'),
('2553','Tamaulipas'),
('2554','Tlaxcala'),
('2555','Veracruz'),
('2556','Yucatán'),
('2557','Zacatecas');
