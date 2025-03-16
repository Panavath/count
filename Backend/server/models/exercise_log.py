# from sqlalchemy import Column, Integer, Float, ForeignKey, DateTime, String
# from sqlalchemy.orm import relationship
# from datetime import datetime

# from database.database import BaseModel


# class ExerciseLogModel(BaseModel):
#     __tablename__ = "ExerciseLog"

#     exercise_log_id = Column(Integer, primary_key=True, index=True)
#     user_id = Column(
#         Integer,
#         ForeignKey("User.user_id"),
#         nullable=False
#     )
#     exercise_type = Column(
#         String,
#         nullable=False
#     )
#     duration_minutes = Column(Float)
#     date = Column(DateTime, default=datetime.now)
#     calories_burned = Column(Float)

#     # Relationships
#     user = relationship("UserModel", back_populates="exercise_logs")
