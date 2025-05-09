# TaskSync

A collaborative task management application built with Supabase and vanilla JavaScript.

## Features

- User authentication (Google OAuth and Email/Password)
- Task management with priorities and deadlines
- Team creation and management
- Task assignment to team members
- Real-time updates using Supabase
- Row Level Security (RLS) for data protection

## Setup

1. **Database Setup**

   - Create a new Supabase project
   - Run the SQL commands from `table_setup_commands.sql` in the Supabase SQL editor
   - This will set up all necessary tables and security policies

2. **Configuration**

   - Replace the Supabase URL and anon key in the following files with your own:
     - `public/auth/login.html`
     - `public/auth/callback.html`
     - `public/index.html`

3. **Google OAuth Setup**

   - In your Supabase project dashboard:
     - Go to Authentication > Providers
     - Enable Google provider
     - Add your application's OAuth callback URL:
       - For local development: `http://localhost:3000/auth/callback`
       - For production: `https://your-domain.com/auth/callback`

4. **Deployment**
   - Deploy the contents of the `public` directory to your web hosting service
   - Ensure all routes are properly configured to serve the HTML files
   - Update the OAuth callback URLs in Supabase to match your production domain

## Local Development

1. Install a local web server (e.g., `live-server` or `http-server`)
2. Run the server from the `public` directory
3. Access the application at `http://localhost:3000`

## Security

- All database access is protected by Row Level Security (RLS) policies
- Users can only access their own data and data shared with them through teams
- API keys are restricted to client-side operations only

## File Structure

```
public/
├── auth/
│   ├── login.html    # Authentication page
│   └── callback.html # OAuth callback handler
├── index.html        # Main application
└── README.md        # Documentation

table_setup_commands.sql  # Database schema and RLS policies
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request
