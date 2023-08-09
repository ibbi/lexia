import { Configuration, OpenAIApi } from 'openai';
import fetchAdapter from '@vespaiach/axios-fetch-adapter';

const personas = {
  grammarAndSpelling:
    'You are a grammar and spelling perfectionist. You rewrite messages to be grammatically correct, with correct punctuation, and free of spelling errors. You do not alter any content besides these corrections. You do not add or remove any words, and you do not swap words for different ones, unless they were used incorrectly. ',
  clearCasual:
    "You are a friendly, familiar communicator. You write very clearly, while maintaining a casual, conversational tone. You aim to strike a balance between clarity and familiarity. You don't use unnecessary words, and keep your communications concise, avoiding qualifiers when they are not absolutely needed. ",
  warmFormal:
    "You are a proactive communicator, engaging directly with the audience. You express your thoughts and needs clearly, while also maintaining a friendly and approachable tone. Your communication style is personal and warm, showing appreciation and understanding for the people you communicate with. You strive for connection, asking for input and encouraging collaboration. You aim to make everyone feel involved and valued. You don't shy away from asking for assistance or support when needed, and you always express gratitude for the help received. Your goal is to foster positive relationships through communication. ",
  rasta: 'You are a rasta. ',
  medieval: 'You are a medieval court jester. ',
  pirate: 'You are a cartoonish pirate. ',
};

const genPrompts = [
  'Write a random, short, 2 sentence informal message or story with a typo.',
  'Write a short 4 sentence story about Lexi the keyboard.',
  'Write a 2 verse poem.',
  'Write a paragraph describing how your day went.',
];

const personaMap = {
  '0': personas.grammarAndSpelling,
  '1': personas.clearCasual,
  '2': personas.warmFormal,
  '3': personas.rasta,
  '4': personas.medieval,
  '5': personas.pirate,
};

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
  if (url.pathname === '/transform') {
    if (request.method !== 'POST') {
      return new Response('Method not allowed', { status: 405 });
    }
    return handleTransformerRequest(request);
  } else if (url.pathname === '/generate') {
    if (request.method !== 'GET') {
      return new Response('Method not allowed', { status: 405 });
    }
    return handleGeneratorRequest(request);
  } else if (url.pathname === '/edit') {
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

async function handleTransformerRequest(request: Request): Promise<Response> {
  try {
    const requestBody = await request.json();
    const userMessage = requestBody.message;
    let rewritePersona = personaMap['0'];
    if (requestBody.prompt in personaMap) {
      rewritePersona = personaMap[requestBody.prompt];
    }
    const promptWrapped = `${rewritePersona}\nRewrite this:\n\n"${userMessage}"`;
    console.log(promptWrapped);

    const response = await openai.createChatCompletion({
      model: 'gpt-4',
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

async function handleGeneratorRequest(request: Request): Promise<Response> {
  try {
    const response = await openai.createChatCompletion({
      model: 'gpt-3.5-turbo',
      messages: [{ role: 'user', content: genPrompts[Math.floor(Math.random() * genPrompts.length)] }],
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
