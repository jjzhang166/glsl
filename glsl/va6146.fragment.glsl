// Someone had to do it :P
//
// Original version is http://glsl.heroku.com/e#6082.0
// Done in about 3 hours on 18.01.2013 by @void256
//
// 20.01.2013:
// - fixed yellow screen of death :)
// - fixed vsync off issue of the game runing way too fast
// - fixed other issues probably due to filterng of the backbuffer read
// - fighting more texture filtering issues :(


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
vec4 white = vec4(1.0, 1.0, 1.0, 1.0);
float screenSizeX = 80.0;
float screenSizeY = 40.0;
float paddleSize = 5.0;
float paddleY = 39.0 - paddleSize;

bool pixel(vec2 pos, float x, float y, float px, float py) {
  if (pos.x >=  x*px &&
      pos.x < (x*px + px) &&
      pos.y >=  y*py &&
      pos.y < (y*py + py)) {
    return true;
  }
  return false;
}

bool statePixel(vec2 pos, float x, float y) {
  if (pos.x >=  x &&
      pos.x < (x + 4.0) &&
      pos.y >=  y &&
      pos.y < (y + 4.0)) {
    return true;
  }
  return false;
}

bool paddle(vec2 pos, float x, float y, float px, float py) {
  if (pos.x >=  x*px &&
      pos.x < (x*px + px) &&
      pos.y >=  y*py &&
      pos.y < (y*py + paddleSize*py)) {
    return true;
  }
  return false;
}

bool isBall(vec4 c) {
  return (c.r == 1.0);
}

bool isNumberVertical(vec2 pos, float x, float y, float px, float py) {
  if (pos.x >=  x*px &&
      pos.x < (x*px + px) &&
      pos.y >=  y*py &&
      pos.y < (y*py + 5.0*py)) {
    return true;
  }
  return false;
}

bool isNumberVerticalHalf(vec2 pos, float x, float y, float px, float py) {
  if (pos.x >=  x*px &&
      pos.x < (x*px + px) &&
      pos.y >=  y*py &&
      pos.y < (y*py + 3.0*py)) {
    return true;
  }
  return false;
}

bool isNumberHorizontal(vec2 pos, float x, float y, float px, float py) {
  if (pos.x >=  x*px &&
      pos.x < (x*px + 3.0*px) &&
      pos.y >=  y*py &&
      pos.y < (y*py + py)) {
    return true;
  }
  return false;
}

bool isNumber(vec2 pos, float x, float y, float n, float px, float py) {
  float number = n;
  if (number > 9.) number = 9.;
  if (number == 0.) {
    if (isNumberHorizontal(pos, x, y, px, py) ||
	isNumberHorizontal(pos, x, y + 4.0, px, py) ||
	isNumberVertical(pos, x, y, px, py) ||
	isNumberVertical(pos, x + 2.0, y, px, py)) {
      return true;
    }
  } else if (number == 1.) {
    if (isNumberVertical(pos, x + 2.0, y, px, py)) {
      return true;
    }
  } else if (number == 2.) {
    if (isNumberHorizontal(pos, x, y, px, py) ||
	isNumberHorizontal(pos, x, y + 2.0, px, py) ||
	isNumberHorizontal(pos, x, y + 4.0, px, py) ||
	isNumberVerticalHalf(pos, x + 0.0, y, px, py) ||
	isNumberVerticalHalf(pos, x + 2.0, y + 2.0, px, py)) {
      return true;
    }
  } else if (number == 3.) {
    if (isNumberHorizontal(pos, x, y, px, py) ||
	isNumberHorizontal(pos, x, y + 2.0, px, py) ||
	isNumberHorizontal(pos, x, y + 4.0, px, py) ||
	isNumberVertical(pos, x + 2.0, y, px, py)) {
      return true;
    }
  } else if (number == 4.) {
    if (isNumberHorizontal(pos, x, y + 2.0, px, py) ||
	isNumberVerticalHalf(pos, x, y + 2.0, px, py) ||
	isNumberVertical(pos, x + 2.0, y, px, py)) {
      return true;
    }
  } else if (number == 5.) {
    if (isNumberHorizontal(pos, x, y, px, py) ||
	isNumberHorizontal(pos, x, y + 2.0, px, py) ||
	isNumberHorizontal(pos, x, y + 4.0, px, py) ||
	isNumberVerticalHalf(pos, x, y + 2.0, px, py) ||
	isNumberVerticalHalf(pos, x + 2.0, y, px, py)) {
      return true;
    }
  } else if (number == 6.) {
    if (isNumberHorizontal(pos, x, y + 0.0, px, py) ||
	isNumberHorizontal(pos, x, y + 2.0, px, py) ||
	isNumberHorizontal(pos, x, y + 4.0, px, py) ||
	isNumberVertical(pos, x, y, px, py) ||
	isNumberVerticalHalf(pos, x + 2.0, y, px, py)) {
      return true;
    }
  } else if (number == 7.) {
    if (isNumberHorizontal(pos, x, y + 4.0, px, py) ||
	isNumberVertical(pos, x + 2.0, y, px, py)) {
      return true;
    }
  } else if (number == 8.) {
    if (isNumberHorizontal(pos, x, y, px, py) ||
	isNumberHorizontal(pos, x, y + 2.0, px, py) ||
	isNumberHorizontal(pos, x, y + 4.0, px, py) ||
	isNumberVertical(pos, x, y, px, py) ||
	isNumberVertical(pos, x + 2.0, y, px, py)) {
      return true;
    }
  } else if (number == 9.) {
    if (isNumberHorizontal(pos, x, y, px, py) ||
	isNumberHorizontal(pos, x, y + 2.0, px, py) ||
	isNumberHorizontal(pos, x, y + 4.0, px, py) ||
	isNumberVerticalHalf(pos, x, y + 2.0, px, py) ||
	isNumberVertical(pos, x + 2.0, y, px, py)) {
      return true;
    }
  }
  return false;
}

void main( void ) {
  vec2 pos = gl_FragCoord.xy;
  float px = resolution.x / screenSizeX;
  float py = resolution.y / screenSizeY;
	
  vec2 pp = 1.0 / resolution.xy;
  vec4 memState = texture2D(backbuffer, vec2(pp.x*12., 0.0));
  vec4 memPos = texture2D(backbuffer, vec2(pp.x*17., 0.0));
  vec4 memDir = texture2D(backbuffer, vec2(pp.x*22., 0.0));
  vec4 color = black;

  float computerPaddleX = 8.0;
  float computerPaddleY = min(1.0 + memPos.y * screenSizeY - paddleSize / 2.0, screenSizeY - paddleSize);//floor(((sin(time) + 1.0) / 2.0) * paddleY);
  float playerPaddleX = 72.0;
  float playerPaddleY = 1.0 + floor(mouse.y * paddleY);

  // ball
  if (memState.r == 1.0 &&
      (memPos.x > 1. / screenSizeX) &&
      pixel(pos, floor(memPos.x * screenSizeX), floor(memPos.y * screenSizeY), px, py)) {
    color = white;
  } else if (statePixel(pos, 10.5, 0.0)) {
    if (memState.r == 0.0) {
      memState.r = 1.0;
      memState.a = 1.0;
      memState.g = 0.0;
      memState.b = 0.0;
    } else {
      if (memPos.x >= 1.00) {
	memState.g += 1. / 10.;
      } else if (memPos.x <= 0.) {
	memState.b += 1. / 10.;
      }

    }
    color = memState;
  } else if (statePixel(pos, 15.5, 0.0)) {
    float r = mod(time, floor(time));
    if (mod(r, 0.05) <= 0.025) {
      if (memDir.a <= 0.00001) {
        memPos.x += 1. / screenSizeX / 4.0;
      } else {
        memPos.x -= 1. / screenSizeX / 4.0;
      }

      if (memDir.b <= 0.00001) {
        memPos.y += 1. / screenSizeY / 4.0;
      } else {
        memPos.y -= 1. / screenSizeY / 4.0;
      }
    }

      if (memPos.x >= 0.999995) {
          memPos.z = 1.0;
	  memPos.x = 0.5;
	  memPos.y = 0.5;
      } else if (memPos.x <= 0.00001) {
          memPos.z = 0.0;
	  memPos.x = 0.5;
	  memPos.y = 0.5;
      }

    color = memPos;
  } else if (statePixel(pos, 20.5, 0.0)) {
      float ballX = floor(memPos.x * screenSizeX);
      float ballY = floor(memPos.y * screenSizeY);
		  
      if (ballX == (playerPaddleX - 1.) &&
	  ballY >= playerPaddleY &&
	  ballY <= playerPaddleY + paddleSize) {
	  memDir.a = 1.0;
      }

      if (ballX == (computerPaddleX + 1.) &&
	  ballY >= computerPaddleY &&
	  ballY <= computerPaddleY + paddleSize) {
	  memDir.a = 0.0;
      }
	  
      if (memPos.x >= 1.0) {
          memDir.a = 1.0;
      } else if (memPos.x <= 0.) {
          memDir.a = 0.0;
      }
      if (memPos.y > 0.99) {
        memDir.b = 1.0;
      } else if (memPos.y < 0.0125) {
	memDir.b = 0.0;
      }
    color = memDir;
  } else if (paddle(pos, 8.0, computerPaddleY, px, py) ||
             paddle(pos, 72.0, playerPaddleY, px, py)) {
    color = white;
  } else if (pixel(pos, screenSizeX / 2.0, screenSizeY / 2.0 - 1.0, px, py) ||
             pixel(pos, screenSizeX / 2.0, screenSizeY / 2.0 + 1.0, px, py) ||
             pixel(pos, screenSizeX / 2.0, screenSizeY / 2.0 - 3.0, px, py) ||
             pixel(pos, screenSizeX / 2.0, screenSizeY / 2.0 + 3.0, px, py) ||
             pixel(pos, screenSizeX / 2.0, screenSizeY / 2.0 - 5.0, px, py) ||
             pixel(pos, screenSizeX / 2.0, screenSizeY / 2.0 + 5.0, px, py) ||
             pixel(pos, screenSizeX / 2.0, screenSizeY / 2.0 - 7.0, px, py) ||
             pixel(pos, screenSizeX / 2.0, screenSizeY / 2.0 + 7.0, px, py) ||
             pixel(pos, screenSizeX / 2.0, screenSizeY / 2.0 - 9.0, px, py) ||
             pixel(pos, screenSizeX / 2.0, screenSizeY / 2.0 + 9.0, px, py) ||
             pixel(pos, screenSizeX / 2.0, screenSizeY / 2.0 - 11.0, px, py) ||
             pixel(pos, screenSizeX / 2.0, screenSizeY / 2.0 + 11.0, px, py) ||
             pixel(pos, screenSizeX / 2.0, screenSizeY / 2.0 - 13.0, px, py) ||
             pixel(pos, screenSizeX / 2.0, screenSizeY / 2.0 + 13.0, px, py) ||
             pixel(pos, screenSizeX / 2.0, screenSizeY / 2.0 - 15.0, px, py) ||
             pixel(pos, screenSizeX / 2.0, screenSizeY / 2.0 + 15.0, px, py) ||
             pixel(pos, screenSizeX / 2.0, screenSizeY / 2.0 - 17.0, px, py) ||
             pixel(pos, screenSizeX / 2.0, screenSizeY / 2.0 + 17.0, px, py)) {
    color = white;
  } else if (isNumber(pos, 25.0, 30.0, ceil(memState.g * 10.0), px, py) ||
	     isNumber(pos, 54.0, 30.0, ceil(memState.b * 10.0), px, py)) {
    color = white;
  }

  gl_FragColor = color;
//  gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
}
