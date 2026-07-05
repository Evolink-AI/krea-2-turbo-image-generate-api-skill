const apiKey = process.env.EVOLINK_API_KEY;
if (!apiKey) {
  throw new Error("Set EVOLINK_API_KEY first");
}

async function requestJson(url, options = {}) {
  const response = await fetch(url, options);
  const text = await response.text();
  const data = text ? JSON.parse(text) : {};
  if (!response.ok) {
    throw new Error(`${response.status} ${response.statusText}: ${JSON.stringify(data)}`);
  }
  return data;
}

const task = await requestJson("https://api.evolink.ai/v1/images/generations", {
  method: "POST",
  headers: {
    Authorization: `Bearer ${apiKey}`,
    "Content-Type": "application/json",
    "X-EvoLink-Source": "skill",
    "X-EvoLink-Skill": "krea-2-turbo-image",
    "X-EvoLink-Package": "evolink-krea-2-turbo",
    "X-EvoLink-Campaign": "krea-2-turbo-image",
    "X-EvoLink-Touchpoint": "first-call"
  },
  body: JSON.stringify({
  "model": "krea-2-turbo",
  "prompt": "A cinematic product poster, silver headphones floating against a deep matte-black backdrop with soft rim lighting",
  "size": "16:9",
  "quality": "1K",
  "nsfw_check": false
})
});

if (!task.id) {
  throw new Error(`Create task did not return id: ${JSON.stringify(task)}`);
}

for (let attempt = 0; attempt < 120; attempt += 1) {
  const current = await requestJson(`https://api.evolink.ai/v1/tasks/${task.id}`, {
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "X-EvoLink-Source": "skill",
      "X-EvoLink-Skill": "krea-2-turbo-image",
      "X-EvoLink-Package": "evolink-krea-2-turbo",
      "X-EvoLink-Campaign": "krea-2-turbo-image",
      "X-EvoLink-Touchpoint": "first-call"
    }
  });

  if (current.status === "completed") {
    console.log(JSON.stringify(current, null, 2));
    process.exit(0);
  }
  if (current.status === "failed") {
    throw new Error(`Task failed: ${JSON.stringify(current)}`);
  }
  await new Promise((resolve) => setTimeout(resolve, 3000));
}

throw new Error(`Timed out waiting for task ${task.id}`);
