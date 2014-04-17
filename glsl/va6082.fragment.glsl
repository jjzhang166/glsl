// Someone had to do it :P
//
// Original version is http://glsl.heroku.com/e#6082.0
// Done in about 3 hours on 18.01.2013 by @void256

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec4 black = vec4(0.0);
vec4 white = vec4(1.0, 1.0, 1.0, 1.0);

float screenSizeX = 80.0;
float screenSizeY = 40.0;

float px = resolution.x / screenSizeX;
float py = resolution.y / screenSizeY;

vec2 pos = gl_FragCoord.xy;

float paddleSize = 5.0;
float paddleY = 39.0 - paddleSize;

bool pixel(float x, float y) {
  if (pos.x >=  x*px &&
      pos.x < (x*px + px) &&
      pos.y >=  y*py &&
      pos.y < (y*py + py)) {
    return true;
  }
  return false;
}

bool statePixel(float x, float y) {
  if (pos.x >=  x &&
      pos.x < (x + 1.0) &&
      pos.y >=  y &&
      pos.y < (y + 1.0)) {
    return true;
  }
  return false;
}

bool paddle(float x, float y) {
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

bool isNumberVertical(float x, float y) {
  if (pos.x >=  x*px &&
      pos.x < (x*px + px) &&
      pos.y >=  y*py &&
      pos.y < (y*py + 5.0*py)) {
    return true;
  }
  return false;
}

bool isNumberVerticalHalf(float x, float y) {
  if (pos.x >=  x*px &&
      pos.x < (x*px + px) &&
      pos.y >=  y*py &&
      pos.y < (y*py + 3.0*py)) {
    return true;
  }
  return false;
}

bool isNumberHorizontal(float x, float y) {
  if (pos.x >=  x*px &&
      pos.x < (x*px + 3.0*px) &&
      pos.y >=  y*py &&
      pos.y < (y*py + py)) {
    return true;
  }
  return false;
}

bool isNumber(float x, float y, float n) {
  float number = n;
  if (number > 9.) number = 9.;
  if (number == 0.) {
    if (isNumberHorizontal(x, y) ||
	isNumberHorizontal(x, y + 4.0) ||
	isNumberVertical(x, y) ||
	isNumberVertical(x + 2.0, y)) {
      return true;
    }
  } else if (number == 1.) {
    if (isNumberVertical(x + 2.0, y)) {
      return true;
    }
  } else if (number == 2.) {
    if (isNumberHorizontal(x, y) ||
	isNumberHorizontal(x, y + 2.0) ||
	isNumberHorizontal(x, y + 4.0) ||
	isNumberVerticalHalf(x + 0.0, y) ||
	isNumberVerticalHalf(x + 2.0, y + 2.0)) {
      return true;
    }
  } else if (number == 3.) {
    if (isNumberHorizontal(x, y) ||
	isNumberHorizontal(x, y + 2.0) ||
	isNumberHorizontal(x, y + 4.0) ||
	isNumberVertical(x + 2.0, y)) {
      return true;
    }
  } else if (number == 4.) {
    if (isNumberHorizontal(x, y + 2.0) ||
	isNumberVerticalHalf(x, y + 2.0) ||
	isNumberVertical(x + 2.0, y)) {
      return true;
    }
  } else if (number == 5.) {
    if (isNumberHorizontal(x, y) ||
	isNumberHorizontal(x, y + 2.0) ||
	isNumberHorizontal(x, y + 4.0) ||
	isNumberVerticalHalf(x, y + 2.0) ||
	isNumberVerticalHalf(x + 2.0, y)) {
      return true;
    }
  } else if (number == 6.) {
    if (isNumberHorizontal(x, y + 0.0) ||
	isNumberHorizontal(x, y + 2.0) ||
	isNumberHorizontal(x, y + 4.0) ||
	isNumberVertical(x, y) ||
	isNumberVerticalHalf(x + 2.0, y)) {
      return true;
    }
  } else if (number == 7.) {
    if (isNumberHorizontal(x, y + 4.0) ||
	isNumberVertical(x + 2.0, y)) {
      return true;
    }
  } else if (number == 8.) {
    if (isNumberHorizontal(x, y) ||
	isNumberHorizontal(x, y + 2.0) ||
	isNumberHorizontal(x, y + 4.0) ||
	isNumberVertical(x, y) ||
	isNumberVertical(x + 2.0, y)) {
      return true;
    }
  } else if (number == 9.) {
    if (isNumberHorizontal(x, y) ||
	isNumberHorizontal(x, y + 2.0) ||
	isNumberHorizontal(x, y + 4.0) ||
	isNumberVerticalHalf(x, y + 2.0) ||
	isNumberVertical(x + 2.0, y)) {
      return true;
    }
  }
  return false;
}

void main( void ) {
  vec2 pp = 1.0 / resolution.xy;
  vec4 memState = texture2D(backbuffer, vec2(0.0, 0.0));
  vec4 memPos = texture2D(backbuffer, vec2(pp.x, 0.0));
  vec4 color = black;

  float computerPaddleX = 8.0;
  float computerPaddleY = min(1.0 + memPos.y * screenSizeY - paddleSize / 2.0, screenSizeY - paddleSize);//floor(((sin(time) + 1.0) / 2.0) * paddleY);
  float playerPaddleX = 72.0;
  float playerPaddleY = 1.0 + floor(mouse.y * paddleY);

  // ball
  if (memState.r == 1.0 && (memPos.x > 1. / screenSizeX) && pixel(floor(memPos.x * screenSizeX), floor(memPos.y * screenSizeY))) {
    color = white;
  } else if (statePixel(0.0, 0.0)) {
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
  } else if (statePixel(1.0, 0.0)) {
      if (memPos.z == 0.0) {
        memPos.x += 1. / screenSizeX / 4.0;
      } else {
        memPos.x -= 1. / screenSizeX / 4.0;
      }

      if (memPos.w == 0.0) {
        memPos.y += 1. / screenSizeY / 4.0;
      } else {
        memPos.y -= 1. / screenSizeY / 4.0;
      }

      float ballX = floor(memPos.x * screenSizeX);
      float ballY = floor(memPos.y * screenSizeY);
		  
      if (ballX == playerPaddleX &&
	  ballY >= playerPaddleY &&
	  ballY <= playerPaddleY + paddleSize) {
	  memPos.z = 1.0;
      }

      if (ballX == computerPaddleX &&
	  ballY >= computerPaddleY &&
	  ballY <= computerPaddleY + paddleSize) {
	  memPos.z = 0.0;
      }

      if (memPos.x >= 1.0) {
          memPos.z = 1.0;
	  memPos.x = 0.5;
	  memPos.y = 0.5;
      } else if (memPos.x <= 0.0) {
          memPos.z = 0.0;
	  memPos.x = 0.5;
	  memPos.y = 0.5;
      }

      if (memPos.y > 0.99) {
        memPos.w = 1.0;
      } else if (memPos.y < 0.0125) {
	memPos.w = 0.0;
      }

    color = memPos;
//    color = vec4(0.0, 0.0, 0.0, 0.0);
  } else if (paddle(8.0, computerPaddleY) ||
             paddle(72.0, playerPaddleY)) {
    color = white;
  } else if (pixel(screenSizeX / 2.0, screenSizeY / 2.0 - 1.0) ||
             pixel(screenSizeX / 2.0, screenSizeY / 2.0 + 1.0) ||
             pixel(screenSizeX / 2.0, screenSizeY / 2.0 - 3.0) ||
             pixel(screenSizeX / 2.0, screenSizeY / 2.0 + 3.0) ||
             pixel(screenSizeX / 2.0, screenSizeY / 2.0 - 5.0) ||
             pixel(screenSizeX / 2.0, screenSizeY / 2.0 + 5.0) ||
             pixel(screenSizeX / 2.0, screenSizeY / 2.0 - 7.0) ||
             pixel(screenSizeX / 2.0, screenSizeY / 2.0 + 7.0) ||
             pixel(screenSizeX / 2.0, screenSizeY / 2.0 - 9.0) ||
             pixel(screenSizeX / 2.0, screenSizeY / 2.0 + 9.0) ||
             pixel(screenSizeX / 2.0, screenSizeY / 2.0 - 11.0) ||
             pixel(screenSizeX / 2.0, screenSizeY / 2.0 + 11.0) ||
             pixel(screenSizeX / 2.0, screenSizeY / 2.0 - 13.0) ||
             pixel(screenSizeX / 2.0, screenSizeY / 2.0 + 13.0) ||
             pixel(screenSizeX / 2.0, screenSizeY / 2.0 - 15.0) ||
             pixel(screenSizeX / 2.0, screenSizeY / 2.0 + 15.0) ||
             pixel(screenSizeX / 2.0, screenSizeY / 2.0 - 17.0) ||
             pixel(screenSizeX / 2.0, screenSizeY / 2.0 + 17.0)) {
    color = white;
  } else if (isNumber(25.0, 30.0, ceil(memState.g * 10.0)) ||
	     isNumber(54.0, 30.0, ceil(memState.b * 10.0))) {
    color = white;
  }

  gl_FragColor = color;
//  gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
}
