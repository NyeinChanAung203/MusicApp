

import uuid
import bcrypt
from fastapi import Depends, HTTPException, Header,status,APIRouter
import jwt

from database import get_db
from middlewares.auth_middleware import auth_middleware
from models.user import User
from pydantic_schemas.user_create import UserCreate
from sqlalchemy.orm import Session,joinedload

from pydantic_schemas.user_login import UserLogin


router = APIRouter()

@router.post('/signup',status_code=status.HTTP_201_CREATED)
def signup_user(user: UserCreate, db: Session = Depends(get_db)):
    print(user.name,user.email,user.password)
    user_db = db.query(User).filter(User.email == user.email).first()
    if user_db:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail= 'User with the same email already exists!')

    # add user to dabase
    hash_pw = bcrypt.hashpw(user.password.encode(),bcrypt.gensalt(16))
    user_db = User(id=str(uuid.uuid4()),name=user.name,email=user.email,password=hash_pw)
    db.add(user_db)
    db.commit()
    db.refresh(user_db)

    return user_db


@router.post('/login')
def login_user(user: UserLogin, db: Session = Depends(get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()

    if not user_db:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail='User with this email does not exist!')
    
    is_match = bcrypt.checkpw(user.password.encode(),user_db.password)
    if not is_match:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail='Incorrect Password')
    
    token = jwt.encode({'id': user_db.id},'password_key')

    return {"token":token,"user": user_db}

@router.get('/')
def current_user_data(db: Session=Depends(get_db),
                      user_dict=Depends(auth_middleware)):
    user = db.query(User).filter(User.id == user_dict['uid']).options(
        joinedload(User.favorites)
    ). first()
    if not user:
        raise HTTPException(status.HTTP_404_NOT_FOUND,'User not found!')
    return user