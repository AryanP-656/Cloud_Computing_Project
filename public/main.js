import { createClient } from "@supabase/supabase-js";

const supabaseUrl = "https://dcaausyumlrnqxvxajzj.supabase.co";
const supabaseKey = process.env.SUPABASE_KEY;
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
