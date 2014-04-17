#ifdef GL_ES
precision highp float;
#endif

// Centipede, maybe?

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

bool IsUninitialized(vec3 color) {
	return (color == vec3(0.0, 0.0, 0.0));
}

bool IsMushroom(vec3 color) {
	return ((color.b > color.r) && (color.b > 0.5));
}

bool IsEnemy(vec3 color) {
	return ((color.g > color.r) && (color.b > 0.5));
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

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;
	vec2 mousepx = mouse * pixel;

	vec3 space = vec3(0.02, 0.04, 0.1);
	vec3 shot = vec3(1.0, 0.0, 0.3);
	vec3 enemy = vec3(0.3, 0.55, 0.65);
	vec3 mushroom = vec3(0.7, 0.2, 1.0);
	vec3 explosion = vec3(0.8, 0.8, 0.2);

	vec4 old = texture2D(backbuffer, position);
	vec4 me = vec4(space.r, space.g, space.b, 1.0);

	// Y < 0.1: ship
	if (position.y < 0.02) {
		// empty; do nothing
	} else if (position.y < 0.05) {
		// Player ship
		if (abs(position.x - mouse.x) < (0.049 - position.y) * 0.5) {
			me.rgb = vec3(0.5, 0.7, 0.6);
		}
	} else if (position.y < 0.06) {
		// Shot generator
		if ((abs(position.x - mouse.x) <= pixel.x) && (mod(time * 20.0, 1.0) < 0.1)) {
			me.rgb = shot;
		}
	} else {
		// Playing field
		float shoty = max(position.y - 0.015, 0.055);
		vec4 below = texture2D(backbuffer, vec2(position.x, shoty));
		float offset = 0.0;
		float offsetpx = 0.0;

		if (IsUninitialized(old.rgb)) {
			// draw playfield for first time
			float enemyrow = (1.0 - position.y) * 45.0;
			float enemyrowmod = mod(enemyrow, 1.0);
			float enemycol = position.x * 80.0;
			float enemycolmod = mod(enemycol, 1.0);
			bool hasmushroom = ((enemyrow >= 1.0) && (mod(time + pow(floor(enemyrow + 223.0), 2.435656) * 0.1234 + pow(floor(enemycol + 362.0), 2.5347345634) * 0.05384, 1.0) < 0.09));

			if ((enemyrow >= 0.0) && (enemyrow < 40.0)) {
				if (hasmushroom && (length(vec2(enemyrowmod * 2.0 - 1.0, enemycolmod * 2.0 - 1.0)) < 0.9)) {
					me.rgb = mushroom;
				}
			}
		} else if (IsShot(below.rgb)) {
			// Move shot up; look for collision w/ enemy or debris
			if (IsEnemy(old.rgb)) {
				me.rgb = explosion;
			} else if (IsMushroom(old.rgb)) {
				me.rgb = explosion;
			} else if (IsDebris(old.rgb)) {
				me.rgb = old.rgb;
			} else {
				me.rgb = shot;
			}
		} else if (IsEnemy(old.rgb) || IsMushroom(old.rgb)) {
			// Grow explosions to consume whole enemy
			bool exploding = 
				(IsExplosion(texture2D(backbuffer, position + vec2(offsetpx + 1.0, 0.0) * pixel).rgb)) ||
				(IsExplosion(texture2D(backbuffer, position + vec2(offsetpx - 1.0, 0.0) * pixel).rgb)) ||
				(IsExplosion(texture2D(backbuffer, position + vec2(offsetpx, 1.0) * pixel).rgb)) ||
				(IsExplosion(texture2D(backbuffer, position + vec2(offsetpx, -1.0) * pixel).rgb));
			me.rgb = exploding ? explosion : old.rgb;
		} else {
			// Fade debris to background color
			if (!IsShot(old.rgb) && !IsEnemy(old.rgb) && !IsMushroom(old.rgb)) {
				float fade = mod(fract(sin(dot(position + time * 0.001, vec2(14.9898,78.233))) * 23451.85353), 1.0);
				fade = pow(fade, 6.0) * 0.4;
				me.rgb = old.rgb * (1.0 - fade) + space * fade;
				if (length(me.rgb - space) < 0.05) {me.rgb = space;}
			}
		}
	}
	gl_FragColor = me;
}