# Truck & Trailer Repair App - Complete Project

A comprehensive, full-stack Truck & Trailer Repair Management Application with Flutter frontend and Python FastAPI backend. This system manages vehicle intake, job assignment, technician work tracking, and provides analytics dashboards for Super Admins and Admins.

---

## 📋 Project Structure

```
Truck & Trailer App/
├── backend/                    # Python FastAPI Backend
│   ├── models/                 # SQLAlchemy ORM Models
│   │   ├── user.py
│   │   ├── inventory/vehicle.py
│   │   ├── jobs/job.py
│   │   ├── history/vehicle_history.py
│   │   ├── analytics/company_analytics.py
│   │   └── logs/system_log.py
│   ├── routers/                # FastAPI Route Handlers
│   │   ├── auth.py             # Authentication endpoints
│   │   ├── inventory.py        # Vehicle intake
│   │   ├── jobs.py             # Job management
│   │   ├── history.py          # Action history
│   │   ├── analytics.py        # Analytics
│   │   └── logs.py             # System logs
│   ├── schemas/                # Pydantic Schemas
│   │   ├── auth.py
│   │   ├── inventory.py
│   │   ├── jobs.py
│   │   ├── history.py
│   │   ├── analytics.py
│   │   └── logs.py
│   ├── core/
│   │   └── config.py           # Configuration settings
│   ├── database.py             # Database connection
│   ├── dependencies.py         # Dependency injection
│   ├── main.py                 # FastAPI app
│   ├── alembic/                # Database migrations
│   ├── requirements.txt        # Python dependencies
│   ├── .env                    # Environment variables
│   └── README.md               # Backend setup guide
│
└── frontend/                   # Flutter App
    ├── lib/
    │   ├── main.dart           # App entry point
    │   ├── screens/
    │   │   ├── auth/           # Login & Signup
    │   │   ├── super_admin/    # Super Admin Dashboard
    │   │   ├── admin/          # Admin Dashboard
    │   │   └── technician/     # Technician Dashboard
    │   ├── models/
    │   │   └── models.dart     # Data models
    │   ├── services/
    │   │   └── api_service.dart # API integration
    │   ├── widgets/            # Reusable widgets
    │   ├── utils/
    │   │   └── routes.dart     # Navigation routing
    │   └── assets/
    ├── pubspec.yaml            # Flutter dependencies
    └── README.md               # Frontend setup guide
```

---

## 🚀 Quick Start

### Backend Setup (Python)

1. **Prerequisites**: Python 3.10+, PostgreSQL

2. **Install dependencies**:
   ```bash
   cd backend
   pip install -r requirements.txt
   ```

3. **Setup PostgreSQL**:
   ```sql
   CREATE DATABASE truck_trailer_db;
   ```

4. **Configure `.env`**:
   ```env
   DATABASE_URL=postgresql+asyncpg://postgres:password@localhost:5432/truck_trailer_db
   SECRET_KEY=your_secret_key_here
   ALGORITHM=HS256
   ACCESS_TOKEN_EXPIRE_MINUTES=30
   ```

5. **Run migrations**:
   ```bash
   alembic upgrade head
   ```

6. **Start the server**:
   ```bash
   uvicorn main:app --reload
   ```

The API will be available at `http://localhost:8000`

### Frontend Setup (Flutter)

1. **Prerequisites**: Flutter 3.0+, Dart 3.0+

2. **Install dependencies**:
   ```bash
   cd frontend
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

---

## 📱 Features

### Authentication System
- **Login & Sign-up**: Role-based registration
- **JWT Authentication**: Secure token-based auth
- **Role Management**: Super Admin, Admin, Technician

### Super Admin Panel
- **Multi-branch Management**: Oversee all branches
- **Global Analytics**: Revenue, repair time, efficiency metrics
- **User Management**: Create and manage admin accounts
- **System Logs**: Audit trails of all actions

### Admin Panel
- **Job Dispatcher**: View and assign pending vehicles to technicians
- **Real-time Monitoring**: Track job status (In-Progress, Paused, Awaiting Parts, Finished)
- **Job Transfer**: Approve tech-to-tech job transfers with reasons
- **Report Generation**: Export repair histories and technician performance

### Technician Module
- **My Tasks**: Clear list of assigned jobs with priority
- **Work Timer**: Start, pause (with reason), resume, finish tracking
- **Issue Logging**: Document problems with text and photos
- **Job Handover**: Request transfers with notes for next technician
- **Documentation**: Step-by-step action logging and checklists

### Inventory & Vehicle Intake
- **Vehicle Admission**: Register trucks and trailers with:
  - Registration/Chassis numbers
  - Serial numbers/VINs
  - Client information
- **Initial Inspection**: Photo and checklist documentation

### History & Documentation
- **Vehicle Lifecycle**: Complete history of every repair visit
- **Action Logs**: Timestamped record of who did what and when
- **Before/After Gallery**: Visual documentation for accountability

---

## 🔌 API Endpoints

### Authentication
- `POST /auth/signup` - Create new user
- `POST /auth/login` - Login and get JWT token

### Inventory
- `POST /inventory/intake` - Admit a vehicle
- `GET /inventory/pending` - Get pending vehicles

### Jobs
- `POST /jobs/assign` - Assign job to technician
- `GET /jobs/pending` - Get pending jobs
- `POST /jobs/update_status` - Update job status

### History
- `GET /history/vehicle/{vehicle_id}` - Get vehicle history
- `POST /history/log_action` - Log an action

### Analytics
- `GET /analytics/company` - Get company analytics

### System Logs
- `GET /logs/` - Get system logs

---

## 🛠 Technology Stack

### Backend
- **Framework**: FastAPI
- **Database**: PostgreSQL
- **ORM**: SQLAlchemy (async)
- **Authentication**: JWT (python-jose)
- **Password Hashing**: bcrypt
- **Migrations**: Alembic
- **CORS**: Enabled for Flutter frontend

### Frontend
- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: Provider
- **HTTP Client**: http
- **Navigation**: go_router
- **UI**: Material 3
- **Local Storage**: shared_preferences

---

## 📦 Database Schema

### Users Table
- id, username, email, hashed_password, role, is_active

### Vehicles Table
- id, type (truck/trailer), registration_number, chassis_number, client_name, intake_time

### Jobs Table
- id, vehicle_id, assigned_to_id, status, issue_log, start_time, pause_time, finish_time

### Vehicle History Table
- id, vehicle_id, job_id, action, performed_by_id, timestamp

### Company Analytics Table
- id, total_revenue, avg_repair_time, branch_count

### System Logs Table
- id, action, user_id, details, timestamp

---

## 🔐 Security Features

1. **Password Hashing**: bcrypt with salt
2. **JWT Authentication**: 30-minute token expiry
3. **Role-Based Access Control**: Different permissions per role
4. **Audit Logs**: All actions timestamped and recorded
5. **CORS Protection**: Configured endpoints

---

## 🎨 UI/UX Highlights

- **Modern Material 3 Design**: Clean, professional interface
- **Dark Mode Support**: (Optional - can be added)
- **Responsive Layout**: Works on all screen sizes
- **Intuitive Navigation**: Role-based dashboards
- **Visual Analytics**: Charts and statistics
- **Card-based Layout**: Easy-to-scan information

---

## 🚧 Future Enhancements

- [ ] Real-time notifications
- [ ] Mobile app for iOS
- [ ] Advanced reporting with PDF export
- [ ] Multi-language support
- [ ] Integration with payment systems
- [ ] GPS tracking for vehicles
- [ ] SMS/Email notifications
- [ ] Dark mode UI
- [ ] Advanced search and filtering
- [ ] Performance analytics dashboard

---

## 📝 Usage Example

### Creating a Job Workflow

1. **Admin admits vehicle**: POST /inventory/intake
2. **Admin assigns job**: POST /jobs/assign
3. **Technician starts work**: POST /jobs/update_status (status: "in_progress")
4. **Technician logs actions**: POST /history/log_action
5. **Technician finishes**: POST /jobs/update_status (status: "finished")
6. **Admin reviews**: GET /history/vehicle/{vehicle_id}

---

## 🐛 Troubleshooting

### Backend Issues
- **Database connection error**: Verify PostgreSQL is running and credentials are correct
- **Port 8000 already in use**: `lsof -i :8000` and kill the process
- **Module import errors**: Ensure all `__init__.py` files exist in model directories

### Frontend Issues
- **Dependencies not loading**: Run `flutter clean && flutter pub get`
- **API connection error**: Verify backend is running on `localhost:8000`
- **Build errors**: Run `flutter doctor` to check environment setup

---

## 📞 Support

For issues, please check the documentation in `/backend/README.md` and `/frontend/README.md`.

---

## 📄 License

This project is proprietary and confidential.

---

## 🎯 Project Status

✅ **Complete** - Full application with all modules implemented and ready for deployment.

