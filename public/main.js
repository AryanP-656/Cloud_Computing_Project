import { createClient } from "@supabase/supabase-js";

const supabaseUrl = "https://dcaausyumlrnqxvxajzj.supabase.co";
const supabaseKey =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRjYWF1c3l1bWxybnF4dnhhanpqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ2MTEzMDYsImV4cCI6MjA2MDE4NzMwNn0.7C_056_X-DN9WBOnVRjgfiL8aEZOccRUH28vvMsS_vw";
const supabase = createClient(supabaseUrl, supabaseKey);

const taskForm = document.getElementById("task-form");
const taskInput = document.getElementById("task-input");
const taskList = document.getElementById("task-list");

// Fetch and show all tasks
async function fetchTasks() {
  const { data, error } = await supabase.from("tasks").select("*");
  if (error) {
    console.error("Error fetching tasks:", error);
    return;
  }

  taskList.innerHTML = ""; // Clear the list
  data.forEach((task) => {
    const li = document.createElement("li");
    li.textContent = task.title; // assuming your table has 'title'
    taskList.appendChild(li);
  });
}

// Insert a new task
async function addTask(title) {
  const { data, error } = await supabase.from("tasks").insert([{ title }]);
  if (error) {
    console.error("Error adding task:", error);
  } else {
    fetchTasks(); // Refresh the list
  }
}

// Handle form submit
taskForm.addEventListener("submit", (e) => {
  e.preventDefault();
  const title = taskInput.value.trim();
  if (title) {
    addTask(title);
    taskInput.value = ""; // Clear input
  }
});

// Initial load
fetchTasks();
