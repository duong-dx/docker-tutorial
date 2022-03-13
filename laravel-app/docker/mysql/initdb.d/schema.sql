CREATE TABLE users(
	id INT AUTO_INCREMENT,
	name VARCHAR(255) NULL,
	email VARCHAR(255) NULL,
	address VARCHAR(255) NULL,
	PRIMARY KEY (id)
);

INSERT INTO users (name, email, address) VALUES
    ('Dinh Xuan Duong', 'xuanduong.kma@gmail.com', 'DA-HN'),
    ('Dinh Xuan Duong1', 'xuanduong1.kma@gmail.com', 'DA-HN');
