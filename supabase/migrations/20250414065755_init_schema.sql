CREATE TABLE tasks (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    title text NOT NULL,
    description text,
    status text DEFAULT 'pending',
    created_at timestamptz DEFAULT now()
);