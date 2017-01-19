--
-- First add the easy user info straight into the user table:
--

ALTER TABLE user ADD user_dob DATE AFTER user_real_name;
ALTER TABLE user ADD user_phone TINYBLOB AFTER user_email;

--
-- Next, create the tables that will store the remainder of the new info:
-- 

-- The "reasons why you, yes you, joined" table 
CREATE TABLE reason /* for joining */ ( 
  reason_user INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT, 
  reason_free_comp BIT(1) DEFAULT 0, 
  reason_build_comp BIT(1) DEFAULT 0, 
  reason_job_skills BIT(1) DEFAULT 0, 
  reason_fg_mission BIT(1) DEFAULT 0, 
  reason_comm_service_req BIT(1) DEFAULT 0, 
  reason_other VARBINARY(255) 
) ENGINE=InnoDB; 

-- Then we can create the emergency contact table 
CREATE TABLE emergency_contact ( 
  ec_user INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT, 
  ec_name VARBINARY(255) NOT NULL, 
  ec_phone VARBINARY(255) NOT NULL, 
  ec_relation VARBINARY(255) NOT NULL 
) ENGINE=InnoDB; 

-- A location table (though, this is going to be trickier in the long run to normalize, probably) 
CREATE TABLE location ( 
  location_id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT, 
  location_name VARBINARY(255), 
  location_address_1 VARBINARY(255) NOT NULL, 
  location_address_2 VARBINARY(255), 
  location_city_id INT(10) UNSIGNED NOT NULL, 
  location_zip INT(10) UNSIGNED NOT NULL, 
  location_coords int(10) DEFAULT NULL 
) ENGINE=InnoDB; 

-- This might be a funny way to do this, but here is the Free Geek specific details 
CREATE TABLE free_geek_deets ( 
  fgs_user INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT, 
  fgs_children_legal BIT(1) DEFAULT 0, 
  fgs_restraining_order BIT(1) DEFAULT 0, 
  fgs_vol_agree BIT(1) DEFAULT 0, 
  fgs_rec_email BIT(1) DEFAULT 0, 
  fgs_find_us VARBINARY(255), 
  fgs_skills VARBINARY(255), 
  fgs_languages VARBINARY(255) DEFAULT '', 
  fgs_work_restrict VARBINARY(255) DEFAULT '' 
) ENGINE=InnoDB; 

-- The program table, which goes with the vol_hours table (see below) 
CREATE TABLE program ( 
  program_id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT, 
  program_name TINYBLOB NOT NULL, 
  program_desc VARBINARY(255) DEFAULT "Eating pizza!" 
) ENGINE=InnoDB; 

-- And the volunteer hours table 
CREATE TABLE vol_hours ( 
  vh_user INT(10) UNSIGNED NOT NULL, 
  vh_location INT(10) UNSIGNED NOT NULL, 
  vh_program INT(10) UNSIGNED NOT NULL, 
  vh_date DATE, vh_time_start TIME, 
  vh_time_stop TIME, 
  FOREIGN KEY (vh_user) REFERENCES user(user_id), 
  FOREIGN KEY (vh_location) REFERENCES location(location_id), 
  FOREIGN KEY (vh_program) REFERENCES program(progam_id) 
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=binary ; 


-- 
-- Now add some foreign keys to connect it all together into some working mess 
-- 

ALTER TABLE user ADD FOREIGN KEY (user_emerg_contact) REFERENCES emergency_contact(ec_user); 
ALTER TABLE user ADD FOREIGN KEY (user_addy) REFERENCES location(location_id); 
ALTER TABLE user ADD FOREIGN KEY (user_reason) REFERENCES reason(reason_user); 
ALTER TABLE user ADD FOREIGN KEY (user_deets) REFERENCES free_geek_deets(fgs_user); 

-- 
-- And that's a wrap 
--
