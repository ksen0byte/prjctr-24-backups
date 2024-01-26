-- Create a sample table
CREATE TABLE IF NOT EXISTS sample_data (
    id SERIAL PRIMARY KEY,
    data VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert initial random data
INSERT INTO sample_data (data) VALUES
('Initial Data 1'),
('Initial Data 2'),
('Initial Data 3');
