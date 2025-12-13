import express from 'express';

const app = express();

app.get('/', (req, res) => {
  //   logger.info('Hello from Acquisitions!');
  res.status(200).send('Hello from Acquisitions!');
});

app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

export default app;
