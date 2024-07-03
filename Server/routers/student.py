from typing import Annotated
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session, joinedload
from fastapi import APIRouter, Depends, HTTPException, Path
from starlette import status
from models import Users, StudyInfo
import models
from database import engine, SessionLocal
from sqlalchemy.orm import Session
from pydantic import BaseModel, Field
from routers.auth import get_current_user, get_user_exception

from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

router = APIRouter( 
    prefix="/student",
    tags=["student"],
    responses={404: {"description": "Not found"}}
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

models.Base.metadata.create_all(bind=engine)

templates = Jinja2Templates(directory="templates")

db_dependency = Annotated[Session, Depends(get_db)]
user_dependency = Annotated[dict, Depends(get_current_user)]
    
@router.get("/", status_code = status.HTTP_200_OK)
async def read_user_all(user: user_dependency, db: db_dependency):
    if user is None:
        raise get_user_exception()
    
    return db.query(Users).all()

@router.get("/info", status_code = status.HTTP_200_OK)
async def read_user_all(user: user_dependency, db: db_dependency):
    if user is None:
        raise get_user_exception()
    
    return db.query(Users).filter(Users.id == user.get('id')).first()
    # 필터 사용. 학습 정보의 owner_id 와 '유저'의 id가 같으면,
    # 사용자의 모든 정보 반환.

    # Join 해서 학습 정보를 반환해야됨. + 노출되는 정보 필터링

@router.get("/id", status_code = status.HTTP_200_OK)
async def read_user_id(user: user_dependency, db: db_dependency):
    if user is None:
        raise get_user_exception()
    
    user_id = db.query(Users.id).filter(Users.id == user.get('id')).first()[0]
    user_id_json = { "id": user_id }
    return user_id_json
    # 필터 사용. 학습 정보의 owner_id 와 '유저'의 id가 같으면,
    # 사용자의 id 반환.


# 학생의 self 학습 정보 반환.
@router.get("/studyinfo", status_code = status.HTTP_200_OK)
async def read_studyinfo_all(user: user_dependency, db: db_dependency):
    if user is None:
        raise get_user_exception()

    user_model = db.query(Users.id, Users.username, Users.age, Users.group).filter(Users.id == user.get('id')).first()

    study_info = db.query(StudyInfo).options(
        joinedload(StudyInfo.correct_problems),
        joinedload(StudyInfo.incorrect_problems)
    ).filter(StudyInfo.id == user.get("id")).first()


    if study_info is None:
        return {'detail':'학습한 정보가 없습니다.'}

    if study_info:
        correct_problems_type1_count = sum(1 for problem in study_info.correct_problems if problem.type == '부정문')
        correct_problems_type2_count = sum(1 for problem in study_info.correct_problems if problem.type == '의문문')
        correct_problems_type3_count = sum(1 for problem in study_info.correct_problems if problem.type == '단어와품사')
        incorrect_problems_type1_count = sum(1 for problem in study_info.correct_problems if problem.type == '부정문')
        incorrect_problems_type2_count = sum(1 for problem in study_info.correct_problems if problem.type == '의문문')
        incorrect_problems_type3_count = sum(1 for problem in study_info.correct_problems if problem.type == '단어와품사')

    return {
        'user_id': user_model[0],
        'name': user_model[1],
        'age': user_model[2],
        'class': user_model[3],
        'type1_True_cnt' : correct_problems_type1_count,
        'type2_True_cnt' : correct_problems_type2_count,
        'type3_True_cnt' : correct_problems_type3_count,
        'type1_False_cnt' : incorrect_problems_type1_count,
        'type2_False_cnt' : incorrect_problems_type2_count,
        'type3_False_cnt' : incorrect_problems_type3_count }

@router.get("/{user_id}", status_code = status.HTTP_200_OK)
async def read_user_studyInfo_all(user: user_dependency, db: db_dependency, user_id : int):
    if user is None:
        raise get_user_exception()
    
    studyinfo_model = db.query(StudyInfo)\
        .filter(StudyInfo.owner_id == user_id)\
        .first()
    if studyinfo_model is not None:
        return studyinfo_model
    raise http_exception()
    # 학습 정보의 owner_id 와 요청한 '유저'의 id가 같으면, 해당 학습 정보 반환.
    # 아직 문제 id만 갖는 상태(Join 안됨)
    # 자신의 학습 기록을 요청하는 API

def successful_response(status_code: int):
    return {
        'status': status_code,
        'detail': 'Successful'
    }

def http_exception():
    return HTTPException(status_code=404, detail="Not found")