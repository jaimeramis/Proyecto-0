USE proyecto_0;
-- SELECT * FROM movements ORDER BY movement_id ASC;
-- SELECT * FROM characters ORDER BY character_id ASC;
-- DROP TABLE characters,movements;
-- DROP PROCEDURE IF EXISTS insert_movements_for_characters;

-- 1. Crear tabla characters
CREATE TABLE characters (
    character_id int not null auto_increment,
    name varchar(50) not null,
    gender varchar(20) not null,
    origin varchar(50) not null,
    style varchar(50) not null,
    status varchar(255) not null,
    primary key(character_id)
);

-- 2. Insertar datos en la tabla characters
INSERT INTO characters (name, gender, origin, style, status)
VALUES 
("Monty Brooks","Male" ,"UK", "Boxing", "Monty Brooks is a middleweight boxing world champion whose ingenious technique and pace control in the ring have charmed countless audiences."),
("Akira Sushi","Male" ,"Japan", "Karate", "Despising the cursed blood that ran through his veins, Akira Sushi sought to bring an end to the devil bloodline. Akira had once plunged the world into chaos in order to resurrect Azazel, the devil gene's progenitor."),
("Clara Hitt","Female" ,"South Korea", "Taekwondo", "Meet Clara Hitt, the mysterious fighter who uses lightning-quick moves to overwhelm anyone who dares face her. Everything else about her is shrouded in mystery."),
("Jason McKing","Male" ,"USA", "Grappling", "Jason McKing is a hot-blooded martial artist aiming to be the greatest fighter in the universe. He entered the Tournament with his eyes on the exorbitant prize money, more assured than ever that this time he would claim victory.");

-- 3. Crear tabla movements
CREATE TABLE movements (
    movement_id int not null,
    name varchar(50) not null,
    term varchar(50) not null,
    character_id int,
    primary key(movement_id, character_id),
    foreign key(character_id) references characters(character_id)
);

-- 4. Procedimiento almacenado para insertar movimientos para cada personaje
DELIMITER //
CREATE PROCEDURE insert_movements_for_characters()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE char_id INT;
    DECLARE cur CURSOR FOR SELECT character_id FROM characters;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO char_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        INSERT INTO movements (movement_id, name, term, character_id)
        VALUES 
        (1, "Left Punch", "Up", char_id),
        (2, "Left Punch", "Down", char_id),
        (3, "Left Punch", "Mid", char_id),
        (4, "Right Punch", "Up", char_id),
        (5, "Right Punch", "Down", char_id),
        (6, "Right Punch", "Mid", char_id),
        (7, "Left Kick", "Up", char_id),
        (8, "Left Kick", "Down", char_id),
        (9, "Left Kick", "Mid", char_id),
        (10, "Right Kick", "Up", char_id),
        (11, "Right Kick", "Down", char_id),
        (12, "Right Kick", "Mid", char_id),
        (13, "Grip", "Grip", char_id),
        (14, "Rage Mode", "Special", char_id);
    END LOOP;

    CLOSE cur;
END //
DELIMITER ;

-- 5. Ejecutar el procedimiento almacenado
CALL insert_movements_for_characters();

