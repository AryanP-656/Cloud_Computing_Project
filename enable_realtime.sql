-- Enable real-time for tasks table
ALTER PUBLICATION supabase_realtime ADD TABLE tasks;

-- Enable real-time for teams table
ALTER PUBLICATION supabase_realtime ADD TABLE teams;

-- Enable real-time for team_members table
ALTER PUBLICATION supabase_realtime ADD TABLE team_members;

-- Set replica identity to full for better real-time data
ALTER TABLE tasks REPLICA IDENTITY FULL;
ALTER TABLE teams REPLICA IDENTITY FULL;
ALTER TABLE team_members REPLICA IDENTITY FULL; 