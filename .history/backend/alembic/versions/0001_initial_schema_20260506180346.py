"""Initial schema.

Revision ID: 0001_initial_schema
Revises:
Create Date: 2026-05-06
"""

from alembic import op
import sqlalchemy as sa

revision = "0001_initial_schema"
down_revision = None
branch_labels = None
depends_on = None

user_role = sa.Enum(
    "super_admin",
    "admin",
    "technician",
    name="userrole",
)

vehicle_type = sa.Enum(
    "truck",
    "trailer",
    name="vehicletype",
)

job_status = sa.Enum(
    "pending",
    "in_progress",
    "paused",
    "awaiting_parts",
    "finished",
    "transferred",
    name="jobstatus",
)


def upgrade() -> None:

    op.create_table(
        "users",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("username", sa.String(), nullable=False),
        sa.Column("email", sa.String(), nullable=False),
        sa.Column("hashed_password", sa.String(), nullable=False),
        sa.Column("is_active", sa.Boolean(), nullable=True),
        sa.Column("role", user_role, nullable=False),
        sa.PrimaryKeyConstraint("id"),
    )

    op.create_index(op.f("ix_users_id"), "users", ["id"], unique=False)
    op.create_index(
        op.f("ix_users_username"),
        "users",
        ["username"],
        unique=True,
    )
    op.create_index(
        op.f("ix_users_email"),
        "users",
        ["email"],
        unique=True,
    )

    op.create_table(
        "vehicles",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("type", vehicle_type, nullable=False),
        sa.Column("registration_number", sa.String(), nullable=True),
        sa.Column("chassis_number", sa.String(), nullable=True),
        sa.Column("serial_number", sa.String(), nullable=True),
        sa.Column("vin", sa.String(), nullable=True),
        sa.Column("client_name", sa.String(), nullable=False),
        sa.Column("client_contact", sa.String(), nullable=True),
        sa.Column("intake_time", sa.DateTime(), nullable=True),
        sa.Column("initial_inspection", sa.Text(), nullable=True),
        sa.Column("admitted_by_id", sa.Integer(), nullable=True),
        sa.ForeignKeyConstraint(
            ["admitted_by_id"],
            ["users.id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )

    op.create_index(
        op.f("ix_vehicles_id"),
        "vehicles",
        ["id"],
        unique=False,
    )

    op.create_index(
        op.f("ix_vehicles_registration_number"),
        "vehicles",
        ["registration_number"],
        unique=False,
    )

    op.create_index(
        op.f("ix_vehicles_chassis_number"),
        "vehicles",
        ["chassis_number"],
        unique=False,
    )

    op.create_index(
        op.f("ix_vehicles_serial_number"),
        "vehicles",
        ["serial_number"],
        unique=False,
    )

    op.create_index(
        op.f("ix_vehicles_vin"),
        "vehicles",
        ["vin"],
        unique=False,
    )

    op.create_table(
        "jobs",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("vehicle_id", sa.Integer(), nullable=False),
        sa.Column("assigned_to_id", sa.Integer(), nullable=True),
        sa.Column("status", job_status, nullable=True),
        sa.Column("issue_log", sa.Text(), nullable=True),
        sa.Column("start_time", sa.DateTime(), nullable=True),
        sa.Column("pause_time", sa.DateTime(), nullable=True),
        sa.Column("resume_time", sa.DateTime(), nullable=True),
        sa.Column("finish_time", sa.DateTime(), nullable=True),
        sa.Column("transfer_reason", sa.Text(), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(
            ["assigned_to_id"],
            ["users.id"],
        ),
        sa.ForeignKeyConstraint(
            ["vehicle_id"],
            ["vehicles.id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )

    op.create_index(
        op.f("ix_jobs_id"),
        "jobs",
        ["id"],
        unique=False,
    )

    op.create_table(
        "company_analytics",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("total_revenue", sa.Float(), nullable=True),
        sa.Column("avg_repair_time", sa.Float(), nullable=True),
        sa.Column("branch_count", sa.Integer(), nullable=True),
        sa.Column("updated_at", sa.DateTime(), nullable=True),
        sa.PrimaryKeyConstraint("id"),
    )

    op.create_index(
        op.f("ix_company_analytics_id"),
        "company_analytics",
        ["id"],
        unique=False,
    )

    op.create_table(
        "system_logs",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("action", sa.String(), nullable=False),
        sa.Column("user_id", sa.Integer(), nullable=True),
        sa.Column("details", sa.Text(), nullable=True),
        sa.Column("timestamp", sa.DateTime(), nullable=True),
        sa.PrimaryKeyConstraint("id"),
    )

    op.create_index(
        op.f("ix_system_logs_id"),
        "system_logs",
        ["id"],
        unique=False,
    )

    op.create_table(
        "vehicle_history",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("vehicle_id", sa.Integer(), nullable=False),
        sa.Column("job_id", sa.Integer(), nullable=False),
        sa.Column("action", sa.Text(), nullable=False),
        sa.Column("performed_by_id", sa.Integer(), nullable=False),
        sa.Column("timestamp", sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(
            ["job_id"],
            ["jobs.id"],
        ),
        sa.ForeignKeyConstraint(
            ["performed_by_id"],
            ["users.id"],
        ),
        sa.ForeignKeyConstraint(
            ["vehicle_id"],
            ["vehicles.id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )

    op.create_index(
        op.f("ix_vehicle_history_id"),
        "vehicle_history",
        ["id"],
        unique=False,
    )


def downgrade() -> None:

    op.drop_index(
        op.f("ix_vehicle_history_id"),
        table_name="vehicle_history",
    )

    op.drop_table("vehicle_history")

    op.drop_index(
        op.f("ix_system_logs_id"),
        table_name="system_logs",
    )

    op.drop_table("system_logs")

    op.drop_index(
        op.f("ix_company_analytics_id"),
        table_name="company_analytics",
    )

    op.drop_table("company_analytics")

    op.drop_index(
        op.f("ix_jobs_id"),
        table_name="jobs",
    )

    op.drop_table("jobs")

    op.drop_index(
        op.f("ix_vehicles_vin"),
        table_name="vehicles",
    )

    op.drop_index(
        op.f("ix_vehicles_serial_number"),
        table_name="vehicles",
    )

    op.drop_index(
        op.f("ix_vehicles_chassis_number"),
        table_name="vehicles",
    )

    op.drop_index(
        op.f("ix_vehicles_registration_number"),
        table_name="vehicles",
    )

    op.drop_index(
        op.f("ix_vehicles_id"),
        table_name="vehicles",
    )

    op.drop_table("vehicles")

    op.drop_index(
        op.f("ix_users_email"),
        table_name="users",
    )

    op.drop_index(
        op.f("ix_users_username"),
        table_name="users",
    )

    op.drop_index(
        op.f("ix_users_id"),
        table_name="users",
    )

    op.drop_table("users")