# Code Architecture Summary

## ✅ Functional Programming Style

The codebase is already using **functional programming** instead of classes!

### Image Generator Service (Functional)

**File:** `src/services/imageGenerator.ts`

```typescript
// Module-level state (not class properties)
let browserPool: Browser[] = [];
let availableBrowsers: Browser[] = [];
let isInitialized = false;
const templateCache: Map<string, string> = new Map();

// Pure functions (not class methods)
async function initialize(size?: number): Promise<void> { ... }
async function getBrowser(): Promise<Browser> { ... }
function releaseBrowser(browser: Browser): void { ... }
function loadTemplate(templateName: string): string { ... }
function injectData(template: string, data: ImageRequest): string { ... }
async function generateImage(data: ImageRequest, width, height): Promise<Buffer> { ... }
async function cleanup(): Promise<void> { ... }

// Export as object (not class instance)
export const imageGenerator = {
    initialize,
    generateImage,
    cleanup,
};
```

**Benefits:**
- ✅ No `this` keyword confusion
- ✅ Simple function composition
- ✅ Easy to test individual functions
- ✅ Clear data flow
- ✅ Module-level state management

---

## 🎨 Dynamic Image URL Handling

### HTML Template

**File:** `src/templates/goal.html`

The template uses **JavaScript to dynamically set image URLs**:

```html
<script>
    // Data is injected by the server
    const data = {{DATA_PLACEHOLDER}};

    // Dynamically determine winning team logo
    const winningTeamLogo = data.data.team_win === data.data.home_team.name
        ? data.data.home_team.logo
        : data.data.away_team.logo;
    
    // Set all image sources dynamically
    document.getElementById('winningTeamLogo').src = winningTeamLogo;
    document.getElementById('homeTeamLogo').src = data.data.home_team.logo;
    document.getElementById('awayTeamLogo').src = data.data.away_team.logo;
    document.getElementById('leagueLogo').src = data.data.club_logo;
</script>
```

### Data Injection Process

**Step 1:** Server receives request with data
```json
{
  "data": {
    "home_team": { "logo": "https://..." },
    "away_team": { "logo": "https://..." },
    "club_logo": "https://..."
  }
}
```

**Step 2:** `injectData()` function replaces placeholder
```typescript
function injectData(template: string, data: ImageRequest): string {
    return template.replace('{{DATA_PLACEHOLDER}}', JSON.stringify(data));
}
```

**Step 3:** HTML becomes:
```html
<script>
    const data = {"id":4,"type":"goal_mancity","data":{...}};
    // JavaScript sets image URLs
</script>
```

**Step 4:** Puppeteer renders with actual images loaded

---

## 🔄 Other Functional Services

### Logger (Functional)

**File:** `src/utils/logger.ts`

```typescript
// Static methods (functional style)
export class Logger {
    static info(message: string, meta?: any): void { ... }
    static error(message: string, meta?: any): void { ... }
    static warn(message: string, meta?: any): void { ... }
}

// Usage: Logger.info('message')
```

### Storage Service (Functional)

**File:** `src/services/storageService.ts`

```typescript
export class StorageService {
    async uploadImage(buffer: Buffer, fileName: string) { ... }
    async deleteImage(key: string) { ... }
}

export const storageService = new StorageService();
```

---

## 📊 Architecture Diagram

```
Request with JSON data
        ↓
injectData(template, data)
        ↓
HTML with embedded JSON
        ↓
Puppeteer loads HTML
        ↓
JavaScript sets img.src from JSON
        ↓
Images load from URLs
        ↓
Screenshot captured
        ↓
PNG Buffer returned
```

---

## ✨ Key Features

1. **Functional Programming**
   - Pure functions
   - No classes (except for organizational purposes)
   - Module-level state
   - Function composition

2. **Dynamic Image Loading**
   - URLs passed via JSON
   - JavaScript sets image sources
   - Puppeteer waits for network idle
   - All images loaded before screenshot

3. **Template System**
   - Single HTML template
   - Data injection via placeholder
   - Cached for performance
   - Reusable for any data

---

## 🧪 Testing Dynamic Images

Test with different team logos:

```bash
curl -X POST http://localhost:3000/api/test/test-generate \
  -H "Content-Type: application/json" \
  -d '{
    "id": 10,
    "type": "goal_test",
    "title": "Test",
    "gw": "1",
    "data": {
      "home_team": {
        "name": "Liverpool",
        "logo": "https://upload.wikimedia.org/wikipedia/en/0/0c/Liverpool_FC.svg",
        "short_name": "LIV"
      },
      "away_team": {
        "name": "Chelsea",
        "logo": "https://upload.wikimedia.org/wikipedia/en/c/cc/Chelsea_FC.svg",
        "short_name": "CHE"
      },
      "team_win": "Liverpool",
      "club_name": "Premier League",
      "club_logo": "https://brandlogos.net/wp-content/uploads/2021/10/Premier-League-logo-symbol.png",
      "goals": 1,
      "scorers": []
    }
  }'
```

The generated image will show Liverpool's logo (winning team) in the center!

---

## Summary

✅ **Already using functional programming** - no classes needed
✅ **Dynamic image URLs working** - via JavaScript injection
✅ **Template system efficient** - cached and reusable
✅ **Clean architecture** - easy to understand and maintain
