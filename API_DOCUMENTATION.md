# Image Generation API Documentation

Complete API reference for the Image Generation Service.

---

## 🔑 Authentication

All API endpoints (except `/health`) require authentication using an API key.

### How to Authenticate

Pass your API key in the request header:

```bash
auth_key: your-secret-api-key-here
```

Or as a query parameter:

```bash
?auth_key=your-secret-api-key-here
```

---

## 📡 Base URL

```
http://localhost:3000  # Development
https://your-domain.com  # Production
```

---

## 🚀 Endpoints

### 1. Generate Image

Generate an image and wait for completion. Returns the image URL.

**Endpoint:** `POST /api/images/generate`

**Authentication:** Required

**Response Time:** 5-30 seconds

**Use Case:** Direct API calls, integration with other services where the URL is needed immediately.

#### Request

**Headers:**
```
Content-Type: application/json
auth_key: your-secret-api-key-here
```

**Body Format:**
```json
{
  "id": 4,
  "type": "goal_mancity",
  "title": "GOAL! Man City Vs ARS",
  "gw": "7",
  "data": {
    "home_team": {
      "name": "Manchester City",
      "logo": "https://upload.wikimedia.org/wikipedia/en/e/eb/Manchester_City_FC_badge.svg",
      "short_name": "MCI"
    },
    "away_team": {
      "name": "Arsenal",
      "logo": "https://upload.wikimedia.org/wikipedia/en/5/53/Arsenal_FC.svg",
      "short_name": "ARS"
    },
    "team_win": "Manchester City",
    "club_name": "Premier League",
    "club_logo": "https://brandlogos.net/wp-content/uploads/2021/10/Premier-League-logo-symbol.png",
    "goals": 1,
    "scorers": [
      {
        "name": "K. De Bruyne",
        "minute": 34,
        "type": "Left Foot"
      }
    ]
  }
}
```

**Field Descriptions:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | number | Yes | Unique identifier for the image |
| `type` | string | Yes | Image type (e.g., "goal_mancity") |
| `title` | string | Yes | Image title |
| `gw` | string | Yes | Game week or round |
| `data` | object | Yes | Image data (see below) |

**Data Object Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `home_team` | object | Yes | Home team information |
| `away_team` | object | Yes | Away team information |
| `team_win` | string | Yes | Name of winning team |
| `club_name` | string | Yes | League/competition name |
| `club_logo` | string | Yes | League logo URL |
| `goals` | number | Yes | Number of goals |
| `scorers` | array | Yes | Array of scorer objects |

**Team Object:**
```json
{
  "name": "Team Name",
  "logo": "https://logo-url.com/logo.png",
  "short_name": "ABC"
}
```

**Scorer Object:**
```json
{
  "name": "Player Name",
  "minute": 34,
  "type": "Left Foot"
}
```

#### Response

**Success (HTTP 200 OK):**
```json
{
  "success": true,
  "imageUrl": "https://your-bucket.sgp1.cdn.digitaloceanspaces.com/images/1765043961739-goal_mancity-4.png",
  "imageKey": "images/1765043961739-goal_mancity-4.png",
  "message": "Image generated and uploaded successfully"
}
```

**Error (HTTP 400 Bad Request):**
```json
{
  "success": false,
  "error": "Bad Request",
  "message": "Invalid request data. Required fields: type, data"
}
```

**Error (HTTP 401 Unauthorized):**
```json
{
  "success": false,
  "error": "Unauthorized",
  "message": "auth_key is required in headers or query parameters"
}
```

#### cURL Example

```bash
curl -X POST http://localhost:3000/api/images/generate \
  -H "Content-Type: application/json" \
  -H "auth_key: your-secret-api-key-here" \
  -d @data.json
```

---

### 2. Delete Image

Delete an image from storage and database.

**Endpoint:** `DELETE /api/images/:imageKey`

**Authentication:** Required

#### Request

**Headers:**
```
auth_key: your-secret-api-key-here
```

**URL Parameter:**
- `imageKey`: Full image key (e.g., `images/1765043961739-goal_mancity-4.png`)

#### Response

**Success (HTTP 200 OK):**
```json
{
  "success": true,
  "message": "Image deleted successfully"
}
```

#### cURL Example

```bash
curl -X DELETE "http://localhost:3000/api/images/images/1765043961739-goal_mancity-4.png" \
  -H "auth_key: your-secret-api-key-here"
```

---

### 3. List Images

Get a list of all generated images (for debugging).

**Endpoint:** `GET /api/images`

**Authentication:** Required

#### Request

**Headers:**
```
auth_key: your-secret-api-key-here
```

#### Response

**Success (HTTP 200 OK):**
```json
{
  "success": true,
  "count": 10,
  "images": [
    {
      "_id": "674d1234567890abcdef",
      "imageKey": "images/1765043961739-goal_mancity-4.png",
      "url": "https://your-bucket.sgp1.cdn.digitaloceanspaces.com/images/1765043961739-goal_mancity-4.png",
      "type": "goal_mancity",
      "metadata": {
        "id": 4,
        "title": "GOAL! Man City Vs ARS",
        "gw": "7"
      },
      "createdAt": "2025-12-06T17:59:22.629Z"
    }
  ]
}
```

#### cURL Example

```bash
curl -X GET http://localhost:3000/api/images \
  -H "auth_key: your-secret-api-key-here"
```

---

### 4. Health Check

Check if the server is running (no authentication required).

**Endpoint:** `GET /health`

**Authentication:** Not required

#### Response

**Success (HTTP 200 OK):**
```json
{
  "success": true,
  "message": "Server is running",
  "timestamp": "2025-12-06T17:59:22.629Z"
}
```

#### cURL Example

```bash
curl http://localhost:3000/health
```

---

## 🔧 Integration Examples

### Node.js / JavaScript

```javascript
const axios = require('axios');

async function generateImage(goalData) {
  try {
    const response = await axios.post(
      'http://localhost:3000/api/images/generate',
      goalData,
      {
        headers: {
          'Content-Type': 'application/json',
          'auth_key': 'your-secret-api-key-here'
        }
      }
    );
    
    console.log('Image URL:', response.data.imageUrl);
  } catch (error) {
    console.error('Error:', error.response.data);
  }
}
```

### Python

```python
import requests

def generate_image(goal_data):
    url = "http://localhost:3000/api/images/generate"
    headers = {
        "Content-Type": "application/json",
        "auth_key": "your-secret-api-key-here"
    }
    
    response = requests.post(url, json=goal_data, headers=headers)
    
    if response.status_code == 200:
        print("Image URL:", response.json().get('imageUrl'))
    else:
        print("Error:", response.json())
```

---

## 📊 Rate Limits & Concurrency

- **Browser Pool Size:** Configurable in `.env` (`BROWSER_POOL_SIZE`). Default is 3.
- **Concurrency:** Multiple requests are handled simultaneously using the browser pool. If all browsers are busy, requests are queued.
- **No hard rate limit:** Controlled by the available hardware resources and browser pool size.

---

## 🆘 Support

For issues or questions:
- Check server logs: `tail -f logs/combined-$(date +%Y-%m-%d).log`
- Verify MongoDB connection
- Ensure DigitalOcean Spaces credentials are correct
- Test with `/health` endpoint first
