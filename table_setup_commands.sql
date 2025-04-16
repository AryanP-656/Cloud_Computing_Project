-- Enable RLS on all tables first
ALTER TABLE IF EXISTS tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS team_members ENABLE ROW LEVEL SECURITY;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS team_members;
DROP TABLE IF EXISTS teams;
DROP TABLE IF EXISTS tasks;
DROP VIEW IF EXISTS public_users;

-- Create a view for public user data
CREATE VIEW public_users AS
    SELECT id, email, raw_user_meta_data
    FROM auth.users;

-- Grant access to the public_users view
GRANT SELECT ON public_users TO anon, authenticated;

-- Create the tasks table first
CREATE TABLE tasks (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    title text NOT NULL,
    description text,
    user_id uuid REFERENCES auth.users(id) NOT NULL,
    status text DEFAULT 'todo',
    created_at timestamptz DEFAULT now(),
    priority text DEFAULT 'medium',
    deadline timestamptz,
    assigned_to uuid REFERENCES auth.users(id)
);

-- Create a teams table for grouping users
CREATE TABLE teams (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    description text,
    created_at timestamptz DEFAULT now(),
    created_by uuid REFERENCES auth.users(id) NOT NULL
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

-- Simple RLS Policies

-- Tasks policies
CREATE POLICY "Users can manage their own tasks"
    ON tasks
    USING (user_id = auth.uid());

CREATE POLICY "Users can view and update assigned tasks"
    ON tasks
    USING (assigned_to = auth.uid());

-- Teams policies
CREATE POLICY "Team creators can manage teams"
    ON teams
    USING (created_by = auth.uid());

CREATE POLICY "Team members can view teams"
    ON teams
    USING (
        EXISTS (
            SELECT 1 FROM team_members
            WHERE team_members.team_id = teams.id
            AND team_members.user_id = auth.uid()
        )
    );

-- Team members policies
CREATE POLICY "Team members can view their teams' members"
    ON team_members
    USING (
        user_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM team_members tm
            WHERE tm.team_id = team_members.team_id
            AND tm.user_id = auth.uid()
        )
    );

CREATE POLICY "Team admins can manage members"
    ON team_members
    USING (
        EXISTS (
            SELECT 1 FROM team_members tm
            WHERE tm.team_id = team_members.team_id
            AND tm.user_id = auth.uid()
            AND tm.role = 'admin'
        )
    );