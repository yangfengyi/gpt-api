import type { VercelRequest, VercelResponse } from '@vercel/node';
import { isAuthed } from '../utils/auth';
import { url2md } from '../routers';

export default async function (req: VercelRequest, res: VercelResponse) {
  // get auth token from header
  const authorization = req.headers.authorization;
  if (!isAuthed(authorization)) {
    res.status(401).end('Unauthorized request');
    return;
  }

  url2md(req, res);
}
