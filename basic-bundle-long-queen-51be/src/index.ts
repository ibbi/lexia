import { Configuration, OpenAIApi } from 'openai';
import fetchAdapter from '@vespaiach/axios-fetch-adapter';

const configuration = new Configuration({
  apiKey: OPENAI_KEY,
  baseOptions: {
    adapter: fetchAdapter,
  },
});

const openai = new OpenAIApi(configuration);
addEventListener('fetch', (event: any) => {
  event.respondWith(handleRequest(event.request));
});

async function handleRequest(request: Request): Promise<Response> {
  const url = new URL(request.url);
  if (url.pathname === '/assembly') {
    if (request.method !== 'GET') {
      return new Response('Method not allowed', { status: 405 });
    }
    return handleAssemblyRequest(request);
  } else if (url.pathname === '/transformer') {
    if (request.method !== 'POST') {
      return new Response('Method not allowed', { status: 405 });
    }
    return handleTransformerRequest(request);
  } else if (url.pathname === '/voice_edit') {
    if (request.method !== 'POST') {
      return new Response('Method not allowed', { status: 405 });
    }
    return handleVoiceEdit(request);
  } else if (url.pathname === '/whisper') {
    if (request.headers.get('Upgrade') === 'websocket') {
      return handleWhisperWebSocket(request);
    } else if (request.method === 'POST') {
      return handleWhisperRequest(request);
    } else {
      return new Response('Method not allowed', { status: 405 });
    }
  } else {
    return new Response('Not found', { status: 404 });
  }
}

async function handleAssemblyRequest(request: Request): Promise<Response> {
  try {
    const response = await fetch('https://api.assemblyai.com/v2/realtime/token', {
      method: 'POST',
      body: JSON.stringify({ expires_in: 3600 }),
      headers: {
        'Content-Type': 'application/json',
        authorization: ASSEMBLY_KEY,
      },
    });
    const data = await response.json();
    return new Response(JSON.stringify(data), {
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }
}

async function handleTransformerRequest(request: Request): Promise<Response> {
  try {
    const requestBody = await request.json();
    const userMessage = requestBody.message;
    const userPrompt = requestBody.prompt || 'Please rewrite this:';
    const promptWrapped = `${userPrompt} \n"${userMessage}"\n:`;

    console.log(promptWrapped);

    const response = await openai.createChatCompletion({
      model: 'gpt-3.5-turbo',
      messages: [{ role: 'user', content: promptWrapped }],
    });

    const assistantMessage = response.data.choices[0].message?.content.replace(/^"(.*)"$/, '$1');
    return new Response(assistantMessage, {
      headers: { 'Content-Type': 'text/plain' },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }
}

async function handleWhisperRequest(request: Request): Promise<Response> {
  try {
    const formData = await request.formData();
    const audioFile = formData.get('file');

    if (!(audioFile instanceof File)) {
      return new Response('Invalid file', { status: 400 });
    }

    formData.append('model', 'whisper-1');

    const response = await fetch('https://api.openai.com/v1/audio/transcriptions', {
      method: 'POST',
      body: formData,
      headers: {
        Authorization: `Bearer ${OPENAI_KEY}`,
      },
    });

    const data = await response.json();
    return new Response(JSON.stringify(data), {
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }
}

async function handleVoiceEdit(request: Request): Promise<Response> {
  try {
    const formData = await request.formData();
    const contextText = formData.get('context');
    const audioFile = formData.get('file');

    if (!(audioFile instanceof File)) {
      return new Response('Invalid file', { status: 400 });
    }

    formData.append('model', 'whisper-1');

    const whisperResponse = await fetch('https://api.openai.com/v1/audio/transcriptions', {
      method: 'POST',
      body: formData,
      headers: {
        Authorization: `Bearer ${OPENAI_KEY}`,
      },
    });
    const { text } = await whisperResponse.json();

    const promptWrapped = `Apply the following instructions:\n---\n${text}\n---\n\nto the following text:\n---\n${contextText}\n---\n`;
    const gptResponse = await openai.createChatCompletion({
      model: 'gpt-3.5-turbo',
      messages: [{ role: 'user', content: promptWrapped }],
    });

    const assistantMessage = gptResponse.data.choices[0].message?.content.replace(/^"(.*)"$/, '$1');

    return new Response(assistantMessage, {
      headers: { 'Content-Type': 'text/plain' },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }
}

async function handleWhisperWebSocket(request: Request): Promise<Response> {
  // @ts-ignore
  const webSocketPair = new WebSocketPair();
  const [client, server] = Object.values(webSocketPair);

  // @ts-ignore
  server.accept();

  // @ts-ignore
  server.addEventListener('message', async (event) => {
    const audioBuffer = new Uint8Array(event.data);
    const formData = new FormData();
    formData.append('file', new Blob([audioBuffer], { type: 'audio/mpeg' }));
    formData.append('model', 'whisper-1');

    const response = await fetch('https://api.openai.com/v1/audio/transcriptions', {
      method: 'POST',
      body: formData,
      headers: {
        Authorization: `Bearer ${OPENAI_KEY}`,
      },
    });

    const data = await response.json();
    const text = data['text'] || '';
    // @ts-ignore
    server.send(text);
  });

  return new Response(null, {
    status: 101,
    // @ts-ignore
    webSocket: client,
  });
}
