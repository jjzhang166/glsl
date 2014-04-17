#ifdef GL_ES
precision highp float;
#endif

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
	return ((color.r == color.g) && (color.r > 0.77));
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
	vec4 me = texture2D(backbuffer, position);

	vec3 space = vec3(0.02, 0.04, 0.1);
	vec3 shot = vec3(1.0, 0.0, 0.3);
	vec3 enemy = vec3(0.3, 0.3, 0.6);
	vec3 explosion = vec3(0.8, 0.8, 0.2);

	vec3 old = me.rgb;
	me.rgb = space;

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
		if ((abs(position.x - mouse.x) <= pixel.x) && (mod(time * 10.0, 1.0) < 0.1)) {
			me.rgb = shot;
		}
	} else {
		// Playing field
		float shoty = max(position.y - 0.015, 0.1025);
		vec4 below = texture2D(backbuffer, vec2(position.x, shoty));
		float offset = 0.0;
		float offsetpx = 0.0;

		if (mod(time * 1.0, 1.0) > 1.95) {
			offset = 0.01;
			offsetpx = 0.01 / pixel.x;
			old = texture2D(backbuffer, position + vec2(offset, 0.0)).rgb;
		}

		if (IsUninitialized(old)) {
			// draw enemy ships for first time
			float enemyrow = (1.0 - position.y - 0.05) * 12.0;
			float enemyrowmod = mod(enemyrow, 1.0);
			float enemycol = position.x * 15.0 - 0.2;
			float enemycolmod = mod(enemycol, 1.0);
			if ((enemyrow >= 0.0) && (enemyrow < 4.0)) {
				if ((enemycol >= 1.0) && (enemycol < 14.0)) {
					me.rgb = alien(enemycolmod * 25.0, enemyrowmod * 25.0) ? enemy : space;
				}
			}
		} else if (IsShot(below.rgb)) {
			if (IsEnemy(old)) {
				me.rgb = explosion;
			} else if (IsDebris(old)) {
				me.rgb = old;
			} else {
				me.rgb = shot;
			}
		} else if (IsEnemy(old)) {
			bool exploding = 
				(IsExplosion(texture2D(backbuffer, position + vec2(offsetpx + 5.0, 0.0) * pixel).rgb)) ||
				(IsExplosion(texture2D(backbuffer, position + vec2(offsetpx - 5.0, 0.0) * pixel).rgb)) ||
				(IsExplosion(texture2D(backbuffer, position + vec2(offsetpx, 5.0) * pixel).rgb)) ||
				(IsExplosion(texture2D(backbuffer, position + vec2(offsetpx, -5.0) * pixel).rgb));
			me.rgb = exploding ? explosion : enemy;
		} else {
			if (!IsShot(old) && !IsEnemy(old)) {
				me.rgb = old.rgb * 0.9 + space * 0.1;
				if (length(me.rgb - space) < 0.05) {me.rgb = space;}
			}
		}
	}
	me.a = 1.0;
	gl_FragColor = me;
}