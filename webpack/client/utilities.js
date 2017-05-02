import client from 'axios';

function getCSRFToken() {
    const el = document.querySelector('meta[name="csrf-token"]');
    return el ? el.getAttribute('content') : '';
}
const axios = client.create({

  baseURL: '/api/v1',
  headers: {
    'Content-Type': 'application/json',
    'X-CSRF-Token': getCSRFToken(),
  },
});

export default axios;