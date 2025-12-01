# Search System - Requirements & Implementation

## Overview
Implement a complete search functionality that allows users to search for products across the entire catalog. Search must be accessible from both the navbar and footer, with results displayed in a dedicated search results page.

**Reference**: https://shop.upsu.net/search

## Functional Requirements

### FR-1: Search Input
- **Description**: Users can enter search queries from multiple locations
- **Acceptance Criteria**:
  - Search input available in navbar (desktop and mobile)
  - Search input available in footer
  - Search input accepts text input
  - Minimum 1 character to trigger search
  - Search triggers on form submit (Enter key or Submit button)
  - Search query preserved in URL as query parameter
  - Search input shows current query on results page

### FR-2: Search Results Page
- **Description**: Dedicated page displays search results
- **Acceptance Criteria**:
  - Route: `/search?q={query}`
  - Display search query prominently
  - Show result count: "X RESULTS FOR '{query}'"
  - Search input pre-filled with current query
  - Submit button to refine search
  - Results displayed in grid layout
  - Mobile: 2 columns
  - Desktop: 3-4 columns
  - Product cards match existing design
  - Empty state for no results
  - Loading state while searching

### FR-3: Search Algorithm
- **Description**: Search matches products based on user query
- **Acceptance Criteria**:
  - Case-insensitive matching
  - Search product names
  - Search product descriptions
  - Search product categories
  - Search collection names
  - Partial word matching
  - Results sorted by relevance:
    1. Exact name matches
    2. Name contains query
    3. Description contains query
    4. Category/collection matches

### FR-4: Search Integration
- **Description**: Search accessible from all pages
- **Acceptance Criteria**:
  - Navbar search icon opens search dialog/input
  - Mobile: Search icon in navbar header
  - Desktop: Search icon in navbar header
  - Footer: Search link navigates to search page
  - All search inputs navigate to `/search` route
  - Query parameter persists in URL

### FR-5: Empty State
- **Description**: User-friendly message when no results found
- **Acceptance Criteria**:
  - Display "No results found" message
  - Show search query that returned no results
  - Suggest alternative actions:
    - Browse all collections
    - Check spelling
    - Try different keywords
  - Maintain search input for query refinement

## Technical Requirements

### TR-1: Search Service
**File**: `lib/services/search_service.dart`

```dart
class SearchService {
  // Search products by query
  Future<List<Product>> searchProducts(String query);
  
  // Get search suggestions (future enhancement)
  Future<List<String>> getSearchSuggestions(String query);
  
  // Search across multiple fields
  List<Product> _filterProducts(List<Product> products, String query);
  
  // Calculate relevance score
  int _calculateRelevance(Product product, String query);
  
  // Sort by relevance
  List<Product> _sortByRelevance(List<Product> products, String query);
}
```

**Search Logic**:
- Load all products from ProductsService
- Filter products by query across multiple fields
- Calculate relevance score for each match
- Sort by relevance (highest first)
- Return sorted list

### TR-2: Search Results Page
**File**: `lib/screens/search_results_page.dart`

**Components**:
- AppBar with back button and title
- Search input form with submit button
- Result count header
- Product grid (responsive)
- Empty state widget
- Loading indicator

**State Management**:
- `_query`: Current search query from URL
- `_results`: List of matching products
- `_isLoading`: Loading state
- `_searchController`: TextEditingController for input

**Lifecycle**:
1. Extract query from route arguments
2. Pre-fill search input
3. Perform search on init
4. Update results
5. Allow search refinement

### TR-3: Navigation Updates

**Navbar Search** (`lib/widgets/navbar.dart`):
- Update search icon button
- Navigate to `/search` on click
- Option 1: Direct navigation with empty query
- Option 2: Show search dialog, then navigate

**Footer Search** (`lib/widgets/footer_widget.dart`):
- Update "Search" link
- Navigate to `/search` route

**Main Routes** (`lib/main.dart`):
- Add `/search` route
- Handle query parameter extraction

### TR-4: Search UI Design

**Search Results Layout**:
```
┌─────────────────────────────┐
│ ← Back    Search Results   │
├─────────────────────────────┤
│ [Search Input] [SUBMIT]     │
├─────────────────────────────┤
│ X RESULTS FOR "query"       │
├─────────────────────────────┤
│ ┌────┐ ┌────┐              │
│ │Prod│ │Prod│              │
│ └────┘ └────┘              │
│ ┌────┐ ┌────┐              │
│ │Prod│ │Prod│              │
│ └────┘ └────┘              │
└─────────────────────────────┘
```

**Empty State**:
```
┌─────────────────────────────┐
│     🔍                       │
│ No results found            │
│                             │
│ We couldn't find any        │
│ products matching "query"   │
│                             │
│ [Browse Collections]        │
└─────────────────────────────┘
```

### TR-5: URL Structure

**Search Route**: `/search?q={query}`

**Examples**:
- `/search?q=hoodie`
- `/search?q=essential`
- `/search?q=sale`
- `/search` (empty query shows all products or prompt)

**Query Parameter Handling**:
- Extract `q` parameter from URL
- Decode URL-encoded query
- Handle special characters
- Handle empty/null query

## Non-Functional Requirements

### NFR-1: Performance
- Search results return within 500ms
- Debounce search input (future enhancement)
- Cache search results (future enhancement)
- Efficient filtering algorithm

### NFR-2: User Experience
- Clear visual feedback during search
- Intuitive empty state messaging
- Responsive design (mobile + desktop)
- Preserve search query in URL for sharing
- Back button returns to previous page

### NFR-3: Accessibility
- Search input has proper label
- Submit button accessible via keyboard
- Results announced to screen readers
- Focus management on search page load

### NFR-4: Error Handling
- Handle invalid queries gracefully
- Handle network errors (if using API)
- Fallback to local search if service fails
- User-friendly error messages

## Implementation Checklist

- [ ] Create SearchService with search logic
- [ ] Implement product filtering by query
- [ ] Add relevance scoring algorithm
- [ ] Create SearchResultsPage widget
- [ ] Add search results grid layout
- [ ] Implement empty state
- [ ] Add loading state
- [ ] Update navbar search icon navigation
- [ ] Update footer search link navigation
- [ ] Add `/search` route to main.dart
- [ ] Handle query parameters from URL
- [ ] Pre-fill search input with current query
- [ ] Test search with various queries
- [ ] Test empty results
- [ ] Test responsive layout
- [ ] Write widget tests
- [ ] Format code
- [ ] Commit changes

## Search Algorithm Details

### Relevance Scoring
Each product receives a score based on:
- **Exact match** (product name == query): +100 points
- **Name starts with** query: +50 points
- **Name contains** query: +25 points
- **Description contains** query: +10 points
- **Category contains** query: +5 points
- **Collection contains** query: +5 points

Sort results by score (descending), then alphabetically by name.

### Search Fields
Search across:
1. Product name (primary)
2. Product description
3. Product category
4. Collection name
5. Product tags (if available)

### Case Sensitivity
- All searches are case-insensitive
- Convert query and search fields to lowercase
- Trim whitespace from query

### Special Characters
- Handle spaces in query
- Allow hyphens, apostrophes
- Strip special characters for matching

## Testing Scenarios

### Test Cases

1. **Basic Search**:
   - Search "hoodie"
   - Verify results contain hoodies
   - Verify result count is correct

2. **Case Insensitivity**:
   - Search "HOODIE"
   - Search "Hoodie"
   - Search "hoodie"
   - All should return same results

3. **Partial Matching**:
   - Search "hood"
   - Should return hoodies
   - Search "essen"
   - Should return essential products

4. **Empty Query**:
   - Submit empty search
   - Show all products OR prompt to enter query

5. **No Results**:
   - Search "xyzabc123"
   - Verify empty state displays
   - Verify helpful message

6. **Multiple Words**:
   - Search "essential hoodie"
   - Should find "Essential Zip Hoodies"

7. **Navigation**:
   - Click navbar search → opens search
   - Click footer search → navigates to search
   - Verify URL updates with query

8. **URL Sharing**:
   - Copy search URL with query
   - Paste in new tab
   - Verify same results load

9. **Responsive Layout**:
   - Test mobile view (2 columns)
   - Test desktop view (3-4 columns)

10. **Performance**:
    - Search with 100+ products
    - Verify results load quickly
    - No UI freezing

## Future Enhancements

### Phase 2 Features:
- **Search Suggestions**: Autocomplete as user types
- **Search History**: Show recent searches
- **Filters on Results**: Filter by price, category, etc.
- **Sort Options**: Sort by price, name, popularity
- **Search Analytics**: Track popular searches
- **Fuzzy Matching**: Handle typos ("hodie" → "hoodie")
- **Search Synonyms**: "sweatshirt" finds "hoodie"

### Advanced Features:
- **Voice Search**: Speech-to-text input
- **Image Search**: Upload image to find similar products
- **Barcode Scanner**: Scan product barcode
- **Search Within Collection**: Scoped search
- **Related Searches**: "People also searched for..."

## Mobile vs Desktop Differences

### Mobile (< 768px):
- Search icon in navbar header
- Full-screen search overlay (optional)
- 2-column product grid
- Larger touch targets
- Sticky search bar

### Desktop (≥ 768px):
- Search icon in navbar header
- Inline search input (optional)
- 3-4 column product grid
- Hover effects on products
- Sidebar filters (future)

## Reference Implementation

Based on https://shop.upsu.net/search:

**Key Features Observed**:
1. Search input at top
2. Submit button next to input
3. Result count header
4. Product grid layout
5. Product cards with images
6. Prices and sale prices displayed
7. Responsive design
8. Clean, minimal UI

**UI Elements**:
- Purple submit button (#4d2963)
- White background
- Grid spacing: 12-16px
- Card shadows on products
- Result count in uppercase

## Success Criteria

- ✅ Search accessible from navbar and footer
- ✅ Search results page displays correctly
- ✅ Products can be found by name/description
- ✅ Result count is accurate
- ✅ Empty state shows for no results
- ✅ URL contains search query
- ✅ Responsive on mobile and desktop
- ✅ No errors or warnings
- ✅ Tests pass
- ✅ Code formatted and committed
