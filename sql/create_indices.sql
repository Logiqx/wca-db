/* 
    Script:   Apply Indices
    Created:  2019-02-15
    Author:   Michael George / 2015GEOR02
   
    Purpose:  Apply indices to the main tables for improved query performance
*/

-- Add primary keys (i.e. store physical records in a clustered index, sorted by the PK)
ALTER TABLE persons ADD PRIMARY KEY(wca_id, sub_id);

-- Create unique indices
CREATE UNIQUE INDEX ranks_average_event_id_person_id ON ranks_average (event_id, person_id);
CREATE UNIQUE INDEX ranks_average_person_id_event_id ON ranks_average (person_id, event_id);
CREATE UNIQUE INDEX ranks_single_event_id_person_id ON ranks_single (event_id, person_id);
CREATE UNIQUE INDEX ranks_single_person_id_event_id ON ranks_single (person_id, event_id);

-- Create non-unique indices
CREATE INDEX results_event_id_person_id ON results (event_id, person_id);
CREATE INDEX results_person_id_event_id ON results (person_id, event_id);
