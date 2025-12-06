# Dynamic Image URL Injection - How It Works

## 📋 Step-by-Step Process

### Step 1: Original HTML Template

**File:** `src/templates/goal.html`

```html
<script>
    const data = {{DATA_PLACEHOLDER}};
    
    // Dynamically set image URLs from data
    document.getElementById('winningTeamLogo').src = 
        data.data.team_win === data.data.home_team.name
            ? data.data.home_team.logo
            : data.data.away_team.logo;
    
    document.getElementById('homeTeamLogo').src = data.data.home_team.logo;
    document.getElementById('awayTeamLogo').src = data.data.away_team.logo;
    document.getElementById('leagueLogo').src = data.data.club_logo;
</script>
```

---

### Step 2: Server Receives Request

```json
{
  "id": 4,
  "type": "goal_mancity",
  "data": {
    "home_team": {
      "name": "Manchester City",
      "logo": "https://upload.wikimedia.org/wikipedia/en/e/eb/Manchester_City_FC_badge.svg"
    },
    "away_team": {
      "name": "Arsenal",
      "logo": "https://upload.wikimedia.org/wikipedia/en/5/53/Arsenal_FC.svg"
    },
    "team_win": "Manchester City",
    "club_logo": "https://brandlogos.net/wp-content/uploads/2021/10/Premier-League-logo-symbol.png"
  }
}
```

---

### Step 3: `injectData()` Function Replaces Placeholder

**Code:** `src/services/imageGenerator.ts`

```typescript
function injectData(template: string, data: ImageRequest): string {
    // Replaces {{DATA_PLACEHOLDER}} with actual JSON
    return template.replace('{{DATA_PLACEHOLDER}}', JSON.stringify(data));
}
```

---

### Step 4: Generated HTML (After Injection)

```html
<script>
    const data = {
        "id": 4,
        "type": "goal_mancity",
        "data": {
            "home_team": {
                "name": "Manchester City",
                "logo": "https://upload.wikimedia.org/wikipedia/en/e/eb/Manchester_City_FC_badge.svg"
            },
            "away_team": {
                "name": "Arsenal",
                "logo": "https://upload.wikimedia.org/wikipedia/en/5/53/Arsenal_FC.svg"
            },
            "team_win": "Manchester City",
            "club_logo": "https://brandlogos.net/wp-content/uploads/2021/10/Premier-League-logo-symbol.png"
        }
    };
    
    // JavaScript executes and sets image sources
    document.getElementById('winningTeamLogo').src = 
        "https://upload.wikimedia.org/wikipedia/en/e/eb/Manchester_City_FC_badge.svg";
    
    document.getElementById('homeTeamLogo').src = 
        "https://upload.wikimedia.org/wikipedia/en/e/eb/Manchester_City_FC_badge.svg";
    
    document.getElementById('awayTeamLogo').src = 
        "https://upload.wikimedia.org/wikipedia/en/5/53/Arsenal_FC.svg";
    
    document.getElementById('leagueLogo').src = 
        "https://brandlogos.net/wp-content/uploads/2021/10/Premier-League-logo-symbol.png";
</script>
```

---

### Step 5: Puppeteer Loads HTML

```typescript
await page.setContent(html, {
    waitUntil: ['networkidle0', 'load'],  // Waits for all images to load!
});
```

**What happens:**
1. Browser loads the HTML
2. JavaScript executes
3. `img.src` attributes are set
4. Browser fetches images from URLs
5. Puppeteer waits for network to be idle (all images loaded)
6. Screenshot is taken

---

## 🎯 Visual Flow

```
Template HTML
    ↓
const data = {{DATA_PLACEHOLDER}};
    ↓
injectData() replaces placeholder
    ↓
const data = {"id":4,"type":"goal_mancity",...};
    ↓
JavaScript executes in browser
    ↓
document.getElementById('winningTeamLogo').src = "https://...";
    ↓
Browser fetches image from URL
    ↓
Image displays in HTML
    ↓
Puppeteer takes screenshot
    ↓
PNG image with actual logos!
```

---

## 🧪 Test to Verify

Run this test to see it working:

```bash
curl -X POST http://localhost:3000/api/test/test-generate \
  -H "Content-Type: application/json" \
  -d '{
    "id": 100,
    "type": "test_dynamic",
    "title": "Dynamic Test",
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

**Expected Result:**
- Image generated with Liverpool logo (center)
- Liverpool logo (left)
- Premier League logo (middle)
- Chelsea logo (right)

Check: `output/test_dynamic-100.png`

---

## 🔍 Key Points

1. **Template has placeholder:** `{{DATA_PLACEHOLDER}}`
2. **Server replaces it:** With `JSON.stringify(data)`
3. **JavaScript runs:** Sets `img.src` from JSON data
4. **Browser loads images:** From the URLs in JSON
5. **Puppeteer waits:** For all images to load (`networkidle0`)
6. **Screenshot taken:** With all images rendered

---

## ✅ Verification

The fix I just made:
- ❌ Before: `{{ DATA_PLACEHOLDER }}` (with spaces)
- ✅ After: `{{DATA_PLACEHOLDER}}` (no spaces)

This ensures the `replace()` function finds and replaces the placeholder correctly!

---

## 📝 Summary

**Dynamic image URLs work because:**
1. URLs are in the JSON data
2. JSON is injected into HTML
3. JavaScript reads JSON and sets `img.src`
4. Browser loads images from URLs
5. Puppeteer captures the rendered result

**No hardcoded URLs needed!** Every image can be different based on the data you send.
