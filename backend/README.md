# Truck & Trailer Repair App Backend

This is the FastAPI backend for the Truck & Trailer Repair App, using PostgreSQL as the database.

## Features
- User authentication (JWT)
- Role-based access (Super Admin, Admin, Technician)
- Inventory & vehicle intake
- Job assignment and tracking
- History and logs
- Analytics

## Tech Stack
- FastAPI
- SQLAlchemy (async)
- PostgreSQL
- Alembic (migrations)
- Python-Jose (JWT)
- Passlib (password hashing)

## Setup
1. Install PostgreSQL and create a database named `truck_trailer_db`.
2. Copy `.env.example` to `.env` and set your DB credentials and secret key.
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Run Alembic migrations:
   ```bash
   alembic upgrade head
   ```
5. Start the server:
   ```bash
   uvicorn backend.main:app --reload
   ```

Run the command from the project root (`Truck  & Trailer App`) so package imports
resolve correctly.
