import { createClient } from "@supabase/supabase-js";

const supabaseUrl = "https://dcaausyumlrnqxvxajzj.supabase.co";
const supabaseKey =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRjYWF1c3l1bWxybnF4dnhhanpqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ2MTEzMDYsImV4cCI6MjA2MDE4NzMwNn0.7C_056_X-DN9WBOnVRjgfiL8aEZOccRUH28vvMsS_vw";
const supabase = createClient(supabaseUrl, supabaseKey);

async function fetchTasks() {
  const { data, error } = await supabase.from("tasks").select("*");

  const tasksContainer = document.getElementById("tasks");

  if (error) {
    console.error("Error fetching tasks:", error);
    tasksContainer.innerText = "Failed to load tasks.";
    return;
  }

  if (data.length === 0) {
    tasksContainer.innerText = "No tasks found.";
    return;
  }

  data.forEach((task) => {
    const taskItem = document.createElement("div");
    taskItem.textContent = task.name || "Unnamed Task"; // Change 'name' to your actual column
    tasksContainer.appendChild(taskItem);
  });
}

fetchTasks();
