import uuid
from fastapi import APIRouter, Depends, File, Form, UploadFile,status
from sqlalchemy.orm import Session,joinedload
from database import get_db
from middlewares.auth_middleware import auth_middleware

import cloudinary
import cloudinary.uploader
from cloudinary.utils import cloudinary_url

from models.favorite import Favorite
from models.song import Song
from pydantic_schemas.favorite_song import FavoriteSong


router = APIRouter()


# Configuration       
cloudinary.config( 
    cloud_name = "daul1tsm5", 
    api_key = "118331135197813", 
    api_secret = "KdSw_8UsnaRwZImUC5orCOGVmzY", # Click 'View Credentials' below to copy your API secret
    secure=True
)

@router.post('/upload',status_code=status.HTTP_201_CREATED)
async def upload_song(song: UploadFile = File(...),
                      thumbnail: UploadFile = File(...),
                      artist: str = Form(...),
                      song_name: str = Form(...),
                      hex_code: str = Form(...),
                      db: Session = Depends(get_db),
                      auth_dict = Depends(auth_middleware)):

    song_id = str(uuid.uuid4())
    song_result = cloudinary.uploader.upload(song.file, resource_type='auto',folder=f'songs/{song_id}')
    print(song_result['url'])
    thumbnail_result = cloudinary.uploader.upload(thumbnail.file, resource_type='image',folder=f'songs/{song_id}')
    print(thumbnail_result['url'])

    new_song = Song(
        id = song_id,
        song_name = song_name,
        artist = artist,
        hex_code = hex_code,
        song_url = song_result['url'],
        thumbnail_url = thumbnail_result['url'],
    )

    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    return new_song


@router.get('/list')
def list_songs(db:Session = Depends(get_db),
               auth_detail = Depends(auth_middleware)):
    songs = db.query(Song).all()
    return songs


@router.post('/favorite')
def favorite_song(song: FavoriteSong, db: Session=Depends(get_db),
                  auth_detail=Depends(auth_middleware)):
    user_id = auth_detail['uid']

    fav_song = db.query(Favorite).filter(Favorite.song_id == song.song_id,Favorite.user_id == user_id).first()

    if fav_song:
        db.delete(fav_song)
        db.commit()
        return {'message':False}
    else:
        new_fav = Favorite(id=str(uuid.uuid4()),user_id=user_id,song_id=song.song_id)
        db.add(new_fav)
        db.commit()
        return {'message':True}
    

@router.get('/list/favorite')
def list_fav_songs(db:Session = Depends(get_db),
               auth_detail = Depends(auth_middleware)):
    user_id = auth_detail['uid']
    songs = db.query(Favorite).filter(Favorite.user_id==user_id).options(
        joinedload(Favorite.song)
    ).all()
    return songs
