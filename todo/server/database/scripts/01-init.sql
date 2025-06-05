CREATE TABLE users (
	id 								UUID PRIMARY KEY NOT NULL,
	username  				VARCHAR(25),
	email 						VARCHAR(30) NOT NULL,
	password 					VARCHAR(100) NOT NULL,
	created_at 				TIMESTAMP NOT NULL,
	deleted_at 				TIMESTAMP,
	recovery_code 		BIGINT,
	recovered_at 			TIMESTAMP,
	is_verified 			BOOLEAN NOT NULL DEFAULT FALSE,
	verified_at 			TIMESTAMP,
	verification_code BIGINT,
	refresh_token     TEXT,
  recovery_mode 		BOOLEAN NOT NULL DEFAULT FALSE

);

CREATE TABLE todos(
	 id 							UUID PRIMARY KEY NOT NULL,
	 user_id 					UUID NOT NULL,
	 title 						VARCHAR(30) NOT NULL,
	 body 						VARCHAR(600) NOT NULL,
	 deadline 				TIMESTAMP,
	 created_at 			TIMESTAMP NOT NULL,
	 completed_at 		TIMESTAMP,
	 is_completed 		BOOLEAN DEFAULT FALSE,
	 FOREIGN KEY (user_id) REFERENCES users(id) 
) ;


