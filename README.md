# TrustNet Backend

> Patching the broken reality between genuine NGOs and willing donors through verified identity, impact proof, and hyper-local community connection.



---

## What is TrustNet?

TrustNet is a verified NGO-donor platform built for **HackByte 4.0** at IIITDM Jabalpur. It addresses the broken trust between NGOs and donors by providing:

- **Verified Identity** — Admin-approved NGO verification with badge system
- **Impact Proof** — NGOs upload proof, admin verifies, badge appears on campaign
- **Hyper-local Discovery** — Find NGOs near you using MongoDB geospatial queries
- **Donor Transparency** — Every donation visible via MongoDB aggregation pipeline
- **Fraud Protection** — Any user can report, admin can remove bad actors instantly

---

## Tech Stack

| Layer | Technology |
|---|---|
| Backend | Spring Boot 3.2.x (Java 21) |
| Database | MongoDB Atlas |
| Payment | Razorpay (test mode) |
| Media | Cloudinary |
| Auth | JWT (jjwt 0.12.3) |
| CI/CD | GitHub Actions |

---

## Project Structure

```
src/main/java/in/the_semicolon_squad/trust_net/
├── controller/         # REST API controllers
├── service/            # Business logic
├── repository/         # MongoDB repositories
├── model/              # MongoDB documents
├── dto/                # Request/Response objects
├── enums/              # Role, VerificationStatus, NotificationType
├── config/             # Security, JWT filter
└── exception/          # Exception handling
```

---

## Getting Started

### Prerequisites
- Java 21
- Maven 3.8+
- MongoDB Atlas account
- Razorpay test account
- Cloudinary account

### Clone the repo
```bash
git clone https://github.com/the-semicolon-squad/ngoconnect-backend.git
cd ngoconnect-backend
```

### Configure environment

Open `src/main/resources/application.properties` and fill in:

```properties
spring.data.mongodb.uri=mongodb+srv://<username>:<password>@<cluster>.mongodb.net/ngoconnect
app.jwt.secret=your_minimum_32_character_secret_key
razorpay.key-id=your_razorpay_key_id
razorpay.key-secret=your_razorpay_key_secret
cloudinary.cloud-name=your_cloud_name
cloudinary.api-key=your_api_key
cloudinary.api-secret=your_api_secret
```

### Run the app
```bash
mvn clean install -DskipTests
mvn spring-boot:run
```

App starts on `http://localhost:8080`

---

## API Overview

### Auth
```
POST /auth/register    — Register as NGO, DONOR, or ADMIN
POST /auth/login       — Login and receive JWT token
```

### NGO
```
PUT  /ngo/profile                    — Update NGO profile
GET  /ngo/profile                    — Get my profile
GET  /ngo/profile/{id}               — Get NGO by ID
GET  /ngo/search?q=                  — Atlas Search full-text
GET  /ngo/nearby?longitude=&latitude=&radius=   — Geospatial discovery
```

### Campaigns
```
POST /campaigns                      — Create campaign
GET  /campaigns/{id}                 — Get campaign
GET  /campaigns/ngo/{ngoId}          — Get NGO campaigns
GET  /campaigns/{id}/transparency    — Donation aggregation by date
POST /campaigns/{id}/proof           — Upload impact proof
POST /campaigns/{id}/outcome         — Post outcome update
```

### Donations
```
POST /donations/initiate             — Create Razorpay order
POST /donations/verify               — Verify payment signature
GET  /donations/{id}/receipt         — Get donation receipt
```

### Posts & Feed
```
POST /posts                          — Create post (verified NGOs only)
GET  /posts/feed                     — Feed from verified NGOs
GET  /posts/ngo/{ngoId}              — Posts by NGO
POST /posts/{postId}/comments        — Add comment
GET  /posts/{postId}/comments        — Get comments
POST /posts/{postId}/like            — Like post
DELETE /posts/{postId}/like          — Unlike post
```

### Volunteer
```
POST /volunteer/posts                          — Create volunteer post
GET  /volunteer/posts/ngo/{ngoId}             — Get volunteer posts
POST /volunteer/posts/{postId}/apply          — Apply
PUT  /volunteer/posts/{postId}/applications/{applicantId}/accept  — Accept
PUT  /volunteer/posts/{postId}/applications/{applicantId}/reject  — Reject
```

### Notifications
```
GET /notifications           — Get unread notifications
GET /notifications/count     — Get unread count
GET /notifications/all       — Get all notifications
PUT /notifications/read      — Mark all as read
```

### Fraud Reports
```
POST /reports                        — Submit report
GET  /reports/admin/pending          — Get pending reports
PUT  /reports/admin/{id}/dismiss     — Dismiss
PUT  /reports/admin/{id}/warn        — Warn NGO
PUT  /reports/admin/{id}/remove      — Remove NGO
```

### Admin
```
GET /admin/verifications/pending           — Pending NGO verifications
PUT /admin/verifications/{id}/approve      — Approve NGO
PUT /admin/verifications/{id}/reject       — Reject NGO
PUT /admin/campaigns/{id}/verify-impact    — Verify impact proof
GET /admin/analytics                       — Platform analytics
```

### Donor
```
GET    /donor/profile            — Get donor profile
POST   /donor/follow/{ngoId}     — Follow NGO
DELETE /donor/unfollow/{ngoId}   — Unfollow NGO
GET    /donor/following          — Get followed NGOs
```

---

## MongoDB Atlas Features Used

| Feature | Implementation |
|---|---|
| Atlas Search | Full-text search on NGO name, cause, description |
| Geospatial | $near operator with 2dsphere index for nearby NGOs |
| Aggregation Pipeline | Donations grouped by date for transparency dashboard |
| Aggregation Pipeline | Platform-wide analytics — total amount raised |

---

## Branch Strategy

```
main  — protected, production-ready, PR only
dev   — active development branch
```

All development happens on `dev`. Features are merged to `main` via Pull Request only.

---

## CI/CD

GitHub Actions pipeline triggers on:
- Push to `main` or `dev`
- Pull Request to `main`

Pipeline steps:
1. Checkout code
2. Setup JDK 21
3. Build with Maven
4. Run tests

---

## Hackathon Tracks

| Track | Integration |
|---|---|
| MongoDB Atlas | Atlas Search, Geospatial, Aggregation Pipeline — core database |
| GitHub | Actions CI/CD, Projects board, branch protection, closed issues |
| Patch the Reality | Verified badge, impact proof, fraud reporting system |
| ROVO | Journey documented across three posts |

---

## Team

**The Semicolon Squad** — HackByte 4.0, IIITDM Jabalpur

---

## License

This project was built for HackByte 4.0 hackathon purposes.