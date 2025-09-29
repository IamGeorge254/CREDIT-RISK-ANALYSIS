SELECT *
FROM credit_risk_data;

# ------ Designing my Tables --------
CREATE TABLE Location (
	location_id INT AUTO_INCREMENT PRIMARY KEY,
	country VARCHAR(100),
    state VARCHAR(100),
    city VARCHAR(100),
    city_latitude DECIMAL(9,6),
    city_longitude DECIMAL(9,6)
);

CREATE TABLE Client (
	client_ID VARCHAR(50) PRIMARY KEY,
    person_age INT,
    person_income DECIMAL(12,2),
    person_home_ownership VARCHAR(50),
    person_emp_length DECIMAL(4,1),
    gender VARCHAR(10),
    marital_status VARCHAR(20),
    education_level VARCHAR(50),
    employment_type VARCHAR(50),
    location_id INT,
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

CREATE TABLE Loans (
	loan_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id VARCHAR(50),
    loan_intent VARCHAR(50),
    loan_grade CHAR(1),
    loan_amnt DECIMAL(12,2),
    loan_int_rate DECIMAL(6,4),
    loan_status TINYINT,
    loan_percent_income DECIMAL(5,2),
    loan_term_months INT,
    loan_to_income_ratio DECIMAL(11,9),
    loan_amnt_bin VARCHAR(20),
    FOREIGN KEY (client_ID) REFERENCES Client(client_ID)
);

CREATE TABLE Credit (
	credit_id INT AUTO_INCREMENT PRIMARY KEY,
    client_ID VARCHAR(50),
	cb_person_default_on_file CHAR(1),
    cb_person_cred_hist_length INT,
    other_debt DECIMAL(18,9),
    debt_to_income_ratio DECIMAL(11,9),
    open_accounts INT,
    credit_utilization_ratio DECIMAL(11,9),
    past_delinquencies INT,
    FOREIGN KEY (client_ID) REFERENCES Client(client_ID)
);


# -------- Inserting Rows to our Tables ---------
# Location table
INSERT INTO Location (country, state, city, city_latitude, city_longitude)
SELECT DISTINCT country, state, city, city_latitude, city_longitude
FROM credit_risk_data;

SELECT *
FROM location;

# Client Table
INSERT INTO Client (
	client_ID, person_age, person_income, person_home_ownership, person_emp_length,
    gender, marital_status, education_level, employment_type, location_id
)
SELECT
	c.client_ID, c.person_age,
    c.person_income, c.person_home_ownership,
    c.person_emp_length, c.gender,
    c.marital_status, c.education_level,
    c.employment_type, l.location_id
FROM credit_risk_data c
JOIN Location l
ON c.country = l.country
	AND c.state = l.state
    AND c.city = l.city;
    
SELECT *
FROM Client;

# Loans Table
INSERT INTO Loans (
	client_id, loan_intent, loan_grade, loan_amnt, loan_int_rate, loan_status, 
    loan_percent_income, loan_term_months, loan_to_income_ratio, loan_amnt_bin
)
SELECT
	client_ID, loan_intent,
    loan_grade, loan_amnt,
    loan_int_rate, loan_status,
    loan_percent_income, loan_term_months,
    loan_to_income_ratio, loan_amnt_bin
FROM credit_risk_data;

SELECT *
FROM Loans;

# Credit Table
INSERT INTO Credit (
    client_ID, cb_person_default_on_file, cb_person_cred_hist_length,
    other_debt, debt_to_income_ratio, open_accounts,
    credit_utilization_ratio, past_delinquencies
)
SELECT 
    client_ID,
    cb_person_default_on_file,
    cb_person_cred_hist_length,
    other_debt,
    debt_to_income_ratio,
    open_accounts,
    credit_utilization_ratio,
    past_delinquencies
FROM credit_risk_data;

# ------ Modifing and Updating our columns in Credit Table ----------
SET SQL_SAFE_UPDATES = 0;
# Rounding Columns to 2 Decimal Places
UPDATE Credit
SET other_debt = ROUND(other_debt, 2),
	debt_to_income_ratio = ROUND(debt_to_income_ratio, 2),
    credit_utilization_ratio = ROUND(credit_utilization_ratio, 2);  
# Fitting the number of decimals
ALTER TABLE Credit
MODIFY other_debt DECIMAL(18,2),
MODIFY debt_to_income_ratio DECIMAL(11,2),
MODIFY credit_utilization_ratio DECIMAL(11,2);

SET SQL_SAFE_UPDATES = 1;

SELECT *
FROM Credit;

# ------ Modifing and Updating our columns in Loans Table ----------
SET SQL_SAFE_UPDATES = 0;
# Rounding Columns to 2 Decimal Places
UPDATE Loans
SET loan_int_rate = ROUND(loan_int_rate, 2),
	loan_to_income_ratio = ROUND(loan_to_income_ratio, 2);
    
# Fitting the number of decimals
ALTER TABLE Loans
MODIFY loan_int_rate DECIMAL(6,2),
MODIFY loan_to_income_ratio DECIMAL(11,2);

SET SQL_SAFE_UPDATES = 1;

SELECT *
FROM Loans;