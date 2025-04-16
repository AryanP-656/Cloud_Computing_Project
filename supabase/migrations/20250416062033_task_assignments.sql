-- Update tasks table to add priority and deadline
ALTER TABLE tasks 
ADD COLUMN priority text DEFAULT 'medium',
ADD COLUMN deadline timestamptz,
ADD COLUMN assigned_to uuid REFERENCES auth.users(id),
ADD COLUMN user_id uuid REFERENCES auth.users(id);

-- Create a teams table for grouping users
CREATE TABLE teams (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    description text,
    created_at timestamptz DEFAULT now(),
    created_by uuid REFERENCES auth.users(id)
);

-- Create a table for team members
CREATE TABLE team_members (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    team_id uuid REFERENCES teams(id) ON DELETE CASCADE,
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
    role text DEFAULT 'member',
    joined_at timestamptz DEFAULT now(),
    UNIQUE (team_id, user_id)
);