(() => {
  // src/index.ts
  addEventListener("fetch", (event) => {
    event.respondWith(handleRequest(event.request));
  });
  async function handleRequest(request) {
    if (request.method !== "GET") {
      return new Response("Method not allowed", { status: 405 });
    }
    try {
      const response = await fetch(
        "https://api.assemblyai.com/v2/realtime/token",
        {
          method: "POST",
          body: JSON.stringify({ expires_in: 3600 }),
          headers: {
            "Content-Type": "application/json",
            authorization: ASSEMBLY_KEY,
          },
        }
      );
      const data = await response.json();
      return new Response(JSON.stringify(data), {
        headers: { "Content-Type": "application/json" },
      });
    } catch (error) {
      return new Response(JSON.stringify({ error: error.message }), {
        status: 500,
      });
    }
  }
})();
//# sourceMappingURL=index.js.map
// hosted at https://basic-bundle-long-queen-51be.ibm456.workers.dev/
