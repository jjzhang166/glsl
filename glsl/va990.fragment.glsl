#ifdef GL_ES
precision highp float;
#endif

// Shader Invaders!!
// Concept & code by Alan Mackey.  Alien graphic by @emackey.
// Original version is http://glsl.heroku.com/424/12

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

bool IsUninitialized(vec3 color) {
	return (color == vec3(0.0, 0.0, 0.0));
}

bool IsEnemy(vec3 color) {
	return ((color.b > color.r) && (color.b > 0.5));
}

bool IsShot(vec3 color) {
	return ((color.r > color.g) && (color.g == 0.0));
}

bool IsExplosion(vec3 color) {
	return ((color.r > 0.5) && (color.g > 0.5));
}

bool IsDebris(vec3 color) {
	if (IsShot(color)) {return false;}
	return (color.r > 0.2);
}

bool alien(float x, float y) {
	if (x > 5.9999) {
		x = 11.0 - x;
	}

	if ((x < -0.0001) || (y < -0.0001)) {
		return false;
	} else if (y <= 1.9999) {
		return (x >= (1.9999 - y));
	} else if (y <= 3.9999) {
		return ((x < 1.9999) || (x >= 3.9999));
	} else if (y <= 7.9999) {
		return true;
	} else if (y <= 10.9999) {
		return ((x >= (10.9999 - y)) && (x <= (12.9999 - y)));
	}
	return false;
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;
	vec2 mousepx = mouse * pixel;

	vec3 space = vec3(0.02, 0.04, 0.1);
	vec3 shot = vec3(1.0, 0.0, 0.3);
	vec3 enemy = vec3(0.3, 0.55, 0.65);
	vec3 explosion = vec3(0.8, 0.8, 0.2);

	vec4 old = texture2D(backbuffer, position);
	vec4 me = vec4(space.r, space.g, space.b, 1.0);

	// Y < 0.1: ship
	if (position.y < 0.02) {
		// empty; do nothing
	} else if (position.y < 0.1) {
		// Player ship
		if (abs(position.x - mouse.x) < (0.1 - position.y) * 0.25) {
			me.rgb = vec3(0.5, 0.7, 0.6);
		}
	} else if (position.y < 0.105) {
		// Shot generator
		if ((abs(position.x - mouse.x) <= pixel.x) && (mod(time * 2.0, 1.0) < 0.1)) {
			me.rgb = shot;
		}
	} else {
		// Playing field
		float shoty = max(position.y - 0.015, 0.1025);
		vec4 below = texture2D(backbuffer, vec2(position.x, shoty));
		float offset = 0.0;
		float offsetpx = 0.0;


		if (IsShot(below.rgb)) {
			// Move shot up; look for collision w/ enemy or debris
				me.rgb = shot;
			
		}
	}
	gl_FragColor = me;
}