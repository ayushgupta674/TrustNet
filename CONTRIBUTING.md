# Contributing to TrustNet Backend

Thank you for contributing to TrustNet. This document explains how to work on this codebase cleanly and consistently.

---

## Branch Strategy

We use two branches:

```
main  — protected, production-ready
dev   — active development, all PRs target this first
```

Never push directly to `main`. All changes go to `dev` first.

---

## Getting Started

### 1. Clone the repo
```bash
git clone https://github.com/the-semicolon-squad/ngoconnect-backend.git
cd ngoconnect-backend
```

### 2. Switch to dev
```bash
git checkout dev
```

### 3. Configure your local environment

Copy and fill in `src/main/resources/application.properties`:

```properties
spring.data.mongodb.uri=mongodb+srv://<username>:<password>@<cluster>.mongodb.net/ngoconnect
app.jwt.secret=your_minimum_32_character_secret_key
razorpay.key-id=your_razorpay_key_id
razorpay.key-secret=your_razorpay_key_secret
cloudinary.cloud-name=your_cloud_name
cloudinary.api-key=your_api_key
cloudinary.api-secret=your_api_secret
```

Never commit real credentials to the repo.

### 4. Run the app
```bash
mvn clean install -DskipTests
mvn spring-boot:run
```

---

## Workflow

### Step 1 — Pick or create a GitHub Issue

Every change must have a corresponding GitHub Issue. If one does not exist, create it first with a clear title:

```
feat: add volunteer matching system
fix: campaign raised amount not updating
chore: update Java version in pom.xml
```

Note the issue number — e.g. `#11`

### Step 2 — Make your changes on dev

```bash
git checkout dev
# make your changes
```

### Step 3 — Commit with issue reference

```bash
git add .
git commit -m "feat: add volunteer matching system closes #11"
git push origin dev
```

The `closes #11` automatically closes the GitHub Issue when merged to main.

### Step 4 — PR from dev to main

When a feature is fully tested:

1. Go to GitHub → Pull Requests → New Pull Request
2. Base: `main` ← Compare: `dev`
3. Write a clear description of what changed
4. Assign yourself
5. Create Pull Request

---

## Commit Message Convention

Follow this format strictly:

```
<type>: <short description> closes #<issue-number>
```

Types:

| Type | When to use |
|---|---|
| `feat` | New feature or API |
| `fix` | Bug fix |
| `chore` | Dependency update, config change |
| `ci` | GitHub Actions changes |
| `docs` | README or documentation only |
| `refactor` | Code restructure, no behavior change |

Examples:
```bash
git commit -m "feat: add Atlas Search for NGO discovery closes #4"
git commit -m "fix: campaign raisedAmount not updating on donation closes #6"
git commit -m "ci: add GitHub Actions pipeline closes #14"
git commit -m "docs: update README with API reference"
```

---

## Code Style

### Package structure
All new code goes in the correct package:

```
controller/   — REST endpoints only, no business logic
service/      — All business logic lives here
repository/   — MongoDB queries only
model/        — MongoDB document definitions
dto/          — Request and response objects
enums/        — Shared enumerations
config/       — Security and configuration beans
```

### Controller rules
- Controllers are thin — they only receive, delegate to service, and return response
- Always use `ResponseEntity<T>` as return type
- Use `@RequestHeader("X-User-Id")` to get current user

```java
// Good
@PostMapping("/campaigns")
public ResponseEntity<Campaign> createCampaign(
        @RequestHeader("X-User-Id") String userId,
        @Valid @RequestBody CampaignRequest request) {
    return ResponseEntity.ok(campaignService.createCampaign(userId, request));
}

// Bad — business logic in controller
@PostMapping("/campaigns")
public ResponseEntity<Campaign> createCampaign(...) {
    NgoProfile profile = ngoProfileRepository.findByUserId(userId); // wrong
    Campaign c = new Campaign();
    c.setNgoId(profile.getId()); // this belongs in service
    ...
}
```

### Service rules
- All database access goes through repositories, never raw MongoTemplate unless aggregation is needed
- Always throw `RuntimeException` with clear message when entity not found
- Use `@RequiredArgsConstructor` for dependency injection — no `@Autowired`

```java
// Good
public Campaign getCampaignById(String id) {
    return campaignRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Campaign not found"));
}
```

### Model rules
- Always use `@Document(collection = "collection_name")` explicitly — never rely on defaults
- Set default values at declaration, not in constructors

```java
// Good
private boolean verifiedBadge = false;
private LocalDateTime createdAt = LocalDateTime.now();
```

### Never do this
- Never put `application.properties` credentials in a commit
- Never write business logic in a controller
- Never access `ngoProfileRepository` from inside `CampaignService` — use `NgoService` instead
- Never use `@Autowired` field injection — use constructor injection via `@RequiredArgsConstructor`

---

## Adding a New Feature

Follow this order every time:

1. Create GitHub Issue
2. Create `enum` values if needed
3. Create `model` (MongoDB document)
4. Create `repository` (MongoRepository interface)
5. Create `dto` (request/response objects)
6. Create `service` (business logic)
7. Create `controller` (REST endpoints)
8. Test via Postman
9. Commit with issue reference
10. Push to dev

---

## Testing

We use Postman for API testing. Before pushing any feature:

1. Test the happy path — correct input, expected output
2. Test the error path — missing fields, wrong IDs, unauthorized access
3. Confirm MongoDB Atlas reflects the changes correctly

Base URL for local testing:
```
http://localhost:8080
```

Required headers on every protected request:
```
Content-Type: application/json
X-User-Id: <userId from login response>
Authorization: Bearer <token from login response>
```

---

## Environment Variables

Never hardcode secrets. Use `application.properties` locally and GitHub Secrets for CI.

GitHub Secrets required:

| Secret | Description |
|---|---|
| `MONGO_URI` | Full MongoDB Atlas connection string |
| `JWT_SECRET` | JWT signing secret (min 32 chars) |

---

## Questions

If something is unclear, open a GitHub Issue with the `question` label before making changes.