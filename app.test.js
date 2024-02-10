const request = require('supertest');
const app = require('./app');

describe('GET /plus/:a/:b', () => {
    it('responds with sum of two positive numbers', async () => {
      const response = await request(app).get('/plus/2/3');
      expect(response.status).toBe(200);
      expect(response.text).toBe('2 + 3 = 5');
    });
  
    it('responds with sum of a positive and a negative number', async () => {
      const response = await request(app).get('/plus/2/-3');
      expect(response.status).toBe(200);
      expect(response.text).toBe('2 + -3 = -1');
    });
  
    it('responds with sum of two negative numbers', async () => {
      const response = await request(app).get('/plus/-2/-3');
      expect(response.status).toBe(200);
      expect(response.text).toBe('-2 + -3 = -5');
    });
  
    it('responds with error if one parameter is not a number', async () => {
      const response = await request(app).get('/plus/a/3');
      expect(response.status).toBe(400);
    });
  
    it('responds with error if both parameters are not numbers', async () => {
      const response = await request(app).get('/plus/a/b');
      expect(response.status).toBe(400);
    });
  
    it('responds with error if one parameter is missing', async () => {
      const response = await request(app).get('/plus/2');
      expect(response.status).toBe(404);
    });
  });
  