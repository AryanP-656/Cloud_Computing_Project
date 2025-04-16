-- Update tasks table to add priority and deadline
ALTER TABLE tasks 
ADD COLUMN priority text DEFAULT 'medium',
ADD COLUMN deadline timestamptz,
ADD COLUMN assigned_to uuid REFERENCES auth.users(id);

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

-- Set up Row Level Security (RLS) policies
-- Teams RLS policies
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;

-- Team members can view teams
CREATE POLICY "Team members can view teams" ON teams
    FOR SELECT USING (
        auth.uid() IN (
            SELECT user_id FROM team_members WHERE team_id = id
        )
    );

-- Only team creators can update or delete
CREATE POLICY "Team creators can update teams" ON teams
    FOR UPDATE USING (auth.uid() = created_by);

CREATE POLICY "Team creators can delete teams" ON teams
    FOR DELETE USING (auth.uid() = created_by);

-- Anyone can create teams
CREATE POLICY "Anyone can create teams" ON teams
    FOR INSERT WITH CHECK (auth.uid() = created_by);

-- Team_members RLS policies
ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;

-- Team members can view members of their teams
CREATE POLICY "Members can view team members" ON team_members
    FOR SELECT USING (
        auth.uid() IN (
            SELECT user_id FROM team_members WHERE team_id = team_members.team_id
        )
    );

-- Team admins can add/update/delete team members
CREATE POLICY "Team admins can manage team members" ON team_members
    FOR ALL USING (
        auth.uid() IN (
            SELECT user_id FROM team_members 
            WHERE team_id = team_members.team_id AND role = 'admin'
        )
    );

-- Tasks RLS policies
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- Users can view tasks they created or are assigned to
CREATE POLICY "Users can view their tasks" ON tasks
    FOR SELECT USING (
        auth.uid() = user_id OR auth.uid() = assigned_to
    );

-- Users can update/delete tasks they created
CREATE POLICY "Users can update their tasks" ON tasks
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their tasks" ON tasks
    FOR DELETE USING (auth.uid() = user_id);

-- Assigned users can update task status
CREATE POLICY "Assigned users can update task status" ON tasks
    FOR UPDATE USING (auth.uid() = assigned_to);

-- Anyone can create tasks
CREATE POLICY "Anyone can create tasks" ON tasks
    FOR INSERT WITH CHECK (auth.uid() = user_id);