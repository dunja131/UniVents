# UniVents
A university events management app that allows students to discover, rsvp and manage their university events. 

## Project Structure
| Folder | Description |
|---|---|
| `/backend` | Spring Boot REST API |
| `/flutter` | Flutter mobile and web app |

## Project Status — Milestone 1

| Feature | Status | Notes |
|---|---|---|
| User Registration | Complete | |
| User Login | Complete | JWT authentication |
| View Events | Complete | Calendar view |
| RSVP to Events | In Progress | Frontend connection pending |
| JWT Authentication | Complete | |
| Database | Complete | PostgreSQL via DBeaver |
| Backend API | Complete | All endpoints tested |
| Flutter Frontend | In Progress | Login, signup, events view done |

## Features (Milestone 1)
- User registration and login
- JWT authentication and authorisation
- View university events in a calendar
- RSVP to events (Going, Maybe, Not Going) — backend complete
- Manage and update RSVPs - backend complete
- Organiser - backend started but for Milestone 2 to complete

- ### Backend Setup
```bash
cd backend
./mvnw spring-boot:run
```
Backend runs on `http://localhost:8080`

### Flutter Setup
```bash
cd flutter
flutter pub get
flutter run
```

### Database Setup
1. Open DBeaver
2. Create a new PostgreSQL database called `univentsdb`
3. Run the schema file: backend/univents_schema.sql


## Testing

### Integration Testing (Postman)
38 automated API tests covering all controllers.

**To run Postman tests:**
1. Import `backend/tests/UniVents_API_Tests.postman_collection.json`
   into Postman
2. Start the Spring Boot backend
3. Run the full collection in order — Login must run first
4. All 38 tests should pass

| Controller | Endpoints Tested | Result |
|---|---|---|
| AuthController | POST /api/auth/login | Pass |
| UserController | POST Register, GET Profile, DELETE User, DELETE User Not Found | Pass |
| EventController | GET, PUT, DELETE | Pass |
| RsvpController | POST, GET, PUT | Pass |

### Manual System Testing
End-to-end testing was performed manually through the Flutter app
verifying signup, login and event viewing workflows.

## Known Issues / Limitations

- `POST /events` requires an `organiser_id` — event creation
  is currently managed directly via the database
- Frontend RSVP connection to backend is in progress
- Password hash is currently exposed in some API responses
  (to be fixed with `@JsonIgnore`)

## Database Schema

PostgreSQL database with the following tables:

| Table | Description |
|---|---|
| `users` | Registered students |
| `events` | University events |
| `rsvps` | Student event RSVPs |
| `organisers` | Event organisers |

## Team — Milestone 1 (roles to be revised for Milestone 2) 

| Member | GitHub | Role |
|---|---|---|
| Kimi Pedebone | dkp333 | Backend |
| Sakshi Pal | SakshiPal941 | Backend |
| Jack | dunja131/KiwKipper | Frontend |
| Anna Loyd | Anna Loyd | Frontend |
