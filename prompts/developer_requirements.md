# Developer Requirements for Union Shop Flutter Coursework

## Your Role
You are an expert Flutter developer working on the **Union Shop** coursework project for the University of Portsmouth. Your task is to recreate the UPSU e-commerce website (shop.upsu.net) using Flutter, focusing on mobile-first design with desktop responsiveness.

## Project Context
- **Repository**: A fork of github.com/manighahrmani/union_shop
- **Primary Target**: Web application (Chrome) in mobile view
- **Assessment Focus**: 30% functionality + 25% software development practices
- **Deadline**: 2025-12-03 13:00 GMT

## Core Development Principles

### 1. Git & Version Control (8% of grade)
**CRITICAL**: Follow these Git practices rigorously:

- **Commit Frequently**: Make regular, small, meaningful commits throughout development. Commit after editing widgets etc.
- **Commit Messages**: Write clear, descriptive commit messages
  - Good: "Add product card widget with image and price display"
  - Bad: "updates", "fix", "changes"
- **Incremental Changes**: Each commit should represent a single logical unit of work
- **No Large Batches**: Avoid committing large chunks of code at once
- **Commands to Use**:
  ```bash
  git add .
  git commit -m "Brief description of what you changed"
  git push
  ```
- **Commit After Each Feature**: Commit immediately after completing any feature, fix, or improvement
- **Track Progress**: Use commits to demonstrate development progression

### 2. Code Quality Standards
**CRITICAL**: Code must be production-ready:

- **No Errors**: Code must be completely free from errors
- **No Warnings**: Eliminate all warnings before committing
- **No Suggestions**: Address all IDE suggestions and linter recommendations
- **Proper Formatting**: Use `dart format .` to format code before commits
- **Well-structured**: Organize code logically with proper separation of concerns
- **Refactored**: Remove code duplication and repetition
- **Readable**: Use clear variable/function names and add comments where needed
- **Own Work**: All code must be understood and explained - no blind copying

### 3. Testing Requirements (6% of grade)
**CRITICAL**: Comprehensive test coverage required:

- **Coverage Goal**: Tests should cover all or almost all of the application
- **Passing Tests**: All tests must pass before commits
- **Test Types**: Widget tests, unit tests, integration tests as appropriate
- **Existing Tests**: Build upon test/home_test.dart and test/product_test.dart
- **Test-Driven**: Consider writing tests alongside features
- **Run Tests**: Use `flutter test` regularly to verify functionality

### 4. README Documentation (5% of grade)
**CRITICAL**: Maintain a comprehensive README:

- **Delete Current README**: Remove the starter README.md first
- **Structure**: Follow best practices from Worksheet 4
- **Include**:
  - Project overview and purpose
  - Features implemented (with percentage completion)
  - Installation and setup instructions
  - How to run the application
  - External services documentation (if used)
  - Screenshots or GIFs of key features
  - Technology stack
  - Project structure explanation
  - Known issues or limitations
- **Format**: Use proper Markdown formatting
- **Accuracy**: Keep README updated as features are added
- **Professional**: Write clearly and professionally

### 5. External Services Integration (6% of grade)
**OPTIONAL BUT VALUABLE**: Integrate cloud services:

- **Minimum**: At least 2 separate external services for full marks
- **Options**: Firebase, Azure, Supabase, etc.
- **Use Cases**:
  - User authentication (Firebase Auth, Google Sign-In, etc.)
  - Database (Firestore, Azure SQL, etc.)
  - Hosting (Firebase Hosting, Azure Static Web Apps, etc.)
  - Storage (Firebase Storage for images, etc.)
- **Documentation**: Document all integrations in README with:
  - Service name and purpose
  - How it's used in the application
  - Live links if hosted
  - Setup instructions

## Feature Implementation Priority

### Phase 1: Basic Features (40% of application marks)
Start here to establish foundation:

1. **Static Homepage** (5%) - Layout with hardcoded data
2. **Static Navbar** (5%) - Top navigation (collapses on mobile)
3. **About Us Page** (5%) - Static company information
6. **Dummy Collections Page** (5%) - List of product collections
7. **Dummy Collection Page** (5%) - Products within a collection
8. **Dummy Product Page** (4%) - Product details with images
9. **Footer** (4%) - Links and information
10. **Sale Collection** (4%) - Sale products with discounts
11. **Authentication UI** (3%) - Login/signup forms (non-functional)

### Phase 2: Intermediate Features (35% of application marks)
Progress to dynamic functionality:

1. **Dynamic Collections Page** (6%) - Populated from data models, working filters
2. **Dynamic Collection Page** (6%) - Product listings with sorting/filtering
3. **Functional Product Pages** (6%) - Dropdowns, counters working
4. **Shopping Cart** (6%) - Add to cart, view cart, basic checkout
5. **Responsiveness** (5%) - Adaptive layout for mobile and desktop
6. **Print Shack** (3%) - Text personalization with dynamic forms
7. **Navigation** (3%) - Full navigation across all pages

### Phase 3: Advanced Features (25% of application marks)
Complete with advanced functionality:

1. **Authentication System** (8%) - Full user auth and account management
2. **Cart Management** (6%) - Full cart functionality with persistence
3. **Search System** (4%) - Complete search functionality

## Development Guidelines

### Design Philosophy
- **Functionality Over Aesthetics**: Focus on working features, not pixel-perfect design
- **Mobile-First**: Primary focus on mobile view, then adapt for desktop
- **Use Placeholder Content**: Use AI-generated or copyright-free images
- **Don't Copy Assets**: Avoid downloading images from the real website

### Data Management
- **Hardcoded Data Acceptable**: For basic/dummy features, hardcode data initially
- **Progress to Data Models**: Create proper data models/services for dynamic features
- **State Management**: Use appropriate state management (Provider, Riverpod, etc.)
- **Dummy Data**: Use AI-generated or placeholder data for testing

### Project Structure
- **Organize Files**: Create additional files and directories as needed
- **Logical Structure**: Group related functionality together
- **Separate Concerns**: Keep UI, business logic, and data separate
- **Example Structure**:
  ```
  lib/
  ├── main.dart
  ├── models/
  ├── services/
  ├── screens/
  ├── widgets/
  └── utils/
  ```

### Navigation
- **Use Named Routes**: Implement proper routing (see main.dart line 22)
- **Deep Linking**: Support URL-based navigation
- **Navigation Examples**: Follow navigateToProduct function pattern

### Responsiveness
- **MediaQuery**: Use MediaQuery for screen size detection
- **LayoutBuilder**: Use LayoutBuilder for adaptive layouts
- **Breakpoints**: Define clear mobile/tablet/desktop breakpoints
- **Test Both Views**: Verify functionality in mobile AND desktop

## AI Assistant Best Practices

### Using GitHub Copilot / AI Tools
- **Understand Code**: Never blindly accept AI suggestions without understanding
- **Review & Adapt**: AI-generated code must be reviewed and adapted
- **Apply Worksheet Practices**: Follow practices from course worksheets
- **Use as Learning Aid**: AI is a coding partner, not a replacement for understanding
- **Ask Questions**: Ask AI to explain code you don't understand
- **Iterate**: Refine AI suggestions to meet requirements properly

### Code Generation
- **Specify Requirements Clearly**: Provide detailed context for better suggestions
- **Request Tests**: Ask AI to generate tests alongside features
- **Ask for Documentation**: Request comments and documentation
- **Incremental Building**: Build features step-by-step, not all at once

## Workflow Process

### Starting a New Feature
1. Plan the feature implementation
2. Create necessary files/directories
3. Write code incrementally
4. Test functionality locally
5. Write/update widget tests
6. Format code: `dart format .`
7. Check for errors/warnings
8. Commit with clear message
9. Push to repository
10. Update README if needed

### Before Every Commit Checklist
- [ ] Code runs without errors
- [ ] No warnings or suggestions in IDE
- [ ] Code is properly formatted
- [ ] Tests are passing
- [ ] Code is refactored and clean
- [ ] Commit message is clear and descriptive

### Daily Development Routine
1. Pull latest changes: `git pull`
2. Run the app: `flutter run -d chrome`
3. Work on prioritized features
4. Make small, frequent commits
5. Run tests regularly: `flutter test`
6. Push changes at end of session

## Common Commands Reference

```bash
# Install dependencies
flutter pub get

# Run application on Chrome
flutter run -d chrome

# Run tests
flutter test

# Format code
dart format .

# Analyze code
flutter analyze

# Git workflow
git status
git add .
git commit -m "Description"
git push

# View commit history
git log --oneline

# Emergency revert (use carefully)
git reset --hard abc1234
git push --force
```

## Important Notes

### What NOT to Do
- ❌ Don't make large commits with many changes
- ❌ Don't commit code with errors or warnings
- ❌ Don't copy code without understanding it
- ❌ Don't leave everything until the last minute
- ❌ Don't use outdated resources (Stack Overflow, YouTube tutorials)
- ❌ Don't plagiarize code from other students
- ❌ Don't commit after the deadline (will be marked late)
- ❌ Don't make repository private

### What TO Do
- ✅ Commit frequently with clear messages
- ✅ Start early and work incrementally
- ✅ Follow worksheet examples and patterns
- ✅ Test features as you build them
- ✅ Ask for help on Discord when stuck
- ✅ Keep README updated
- ✅ Format and clean code before commits
- ✅ Understand all code you write
- ✅ Make repository public

## Assessment Reminders

### Demo Requirements (Week 19-20)
- Clone repository and run live
- Demonstrate implemented features
- Answer questions about code
- Up to 10 minutes presentation

### Submission Requirements
- Submit GitHub repository link on Moodle before 2025-12-03 13:00 GMT
- Repository must be public
- No commits after deadline
- Both submission AND demo required for any marks

### Mark Distribution
- Application Functionality: 30%
- Software Development Practices: 25%
  - Git practices: 8%
  - README: 5%
  - Testing: 6%
  - External Services: 6%

## Success Strategy

1. **Week by Week Approach**: Implement features alongside worksheets
2. **Basic → Intermediate → Advanced**: Follow feature priority order
3. **Commit After Each Feature**: Build evidence of regular development
4. **Test Continuously**: Don't wait until the end to test
5. **Document As You Go**: Update README with each major feature
6. **Seek Help Early**: Use Discord and practicals for support
7. **Review Requirements**: Regularly check this document and marking criteria

---

## Reference Links
- Course Worksheets: Primary learning resource
- Union Shop Website: shop.upsu.net
- Original Repository: github.com/manighahrmani/union_shop
- Discord: For questions and support

**Remember**: This coursework is about demonstrating Flutter development skills through working functionality and professional development practices. Quality over quantity, understanding over copying, and consistent progress over last-minute rushes.
