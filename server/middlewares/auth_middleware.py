from fastapi import HTTPException, Header,status
import jwt

def auth_middleware(x_auth_token = Header()):
    try:

        # get user token from the header
        if not x_auth_token:
            raise HTTPException(status.HTTP_401_UNAUTHORIZED,'No auth token, access denied')
        # decode the token
        verified_token = jwt.decode(x_auth_token,'password_key',['HS256'])
        if not verified_token:
            raise HTTPException(status.HTTP_401_UNAUTHORIZED,'Token verification failed, authorization denied')

        # get id from the token
        uid = verified_token.get('id')
        return {'uid': uid, 'token': x_auth_token}
        # postgre get user data
    except jwt.PyJWTError:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED,'Token is not valid, authorization failed')
