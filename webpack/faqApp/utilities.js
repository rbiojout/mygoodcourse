import client from 'axios';
import { CLIENT_ROOT_URL } from '../shared/constants/apis';

export function getCSRFToken() {
    const el = document.querySelector('meta[name="csrf-token"]');
    return el ? el.getAttribute('content') : '';
}

export function capitalize(string) {
    return (string.substring(0, 1).toUpperCase() + string.substring(1));
}

export const axios = client.create({

  baseURL: CLIENT_ROOT_URL,
  headers: {
    'Content-Type': 'application/json',
    'X-CSRF-Token': getCSRFToken(),
  },
});

