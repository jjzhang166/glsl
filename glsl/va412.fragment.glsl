#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec3 blank;

vec4 neighbor(float x, float y) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;
	vec2 diff = vec2(x, -y);
	return texture2D(backbuffer, position + diff * pixel);
}

bool CanFallDown(float x, float y) {
	if (neighbor(x, y).rgb == blank) {return false;}
	if (neighbor(x, y + 1.0).rgb != blank) {return false;}
	return true;
}

bool CanTumble(float x, float y, float direction) {
	if (neighbor(x, y).rgb == blank) {return false;}
	if (neighbor(x, y + 1.0).rgb == blank) {return false;}
	if (neighbor(x + direction, y + 1.0).rgb != blank) {return false;}
	if (neighbor(x + direction, y).rgb != blank) {return false;}
	return true;
}

bool CanScoot(float x, float y, float direction) {
	return false;
	if (neighbor(x, y).rgb == blank) {return false;}
	if (neighbor(x + direction, y).rgb != blank) {return false;}
	if (neighbor(x, y + 1.0).rgb == blank) {return false;}
	if (neighbor(x + direction, y + 1.0).rgb == blank) {return false;}
	return true;
}


void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;
	vec2 mousepx = mouse * pixel;

	blank = vec3(10.0 / 255.0, 40.0 / 255.0, 80.0 / 255.0);
	//float bias = (sin(time * 1428.5453) > 0.0) ? 1.0 : -1.0;
	float bias = ((mod(time * 4.0, 1.0)) > 0.5) ? 1.0 : -1.0;
	//float bias = 1.0;

	float rnd1 = mod(fract(sin(dot(position + time * 0.001, vec2(14.9898,78.233))) * 43758.5453), 1.0);
	float rnd2 = mod(fract(sin(dot(position + time * 0.001, vec2(14.9898,78.233))) * 37735.2464), 1.0);
	float rnd3 = mod(fract(sin(dot(position + time * 0.001, vec2(14.9898,78.233))) * 62463.1234), 1.0);
	vec3 sand = vec3((150.0 + 100.0 * rnd1) / 255.0, (100.0 + 100.0 * rnd2) / 255.0 , (50.0 + 100.0 * rnd3) / 255.0);

	vec4 me = texture2D(backbuffer, position);

	if (me.rgb == vec3(0.0, 0.0, 0.0)) {
		me.rgb = blank;
	} else if (gl_FragCoord.y >= resolution.y - 2.0) {
		// Keep top pixel blank
		me.rgb = blank;
	} else if (length(mouse - position) < 0.015) {
		// Mouse toggles sand
		if (mouse.y > 0.25) {
			me.rgb = sand;
		} else {
			me.rgb = blank;
		}
	} else if (CanFallDown(0.0, -1.0)) {
		// Sand falls straight down if there's room
		me.rgb = neighbor(0.0, -1.0).rgb;
	} else if (CanTumble(-bias, -1.0, bias)) {
		// Sand tumbles downhill left if it can't fall straight down
		me.rgb = neighbor(-bias, -1.0).rgb;
	} else if ((CanTumble(bias, -1.0, -bias)) && (!CanTumble(bias, -1.0, bias))) {
		// Sand tumbles downhill right if it can't fall straight down or tumble right
		me.rgb = neighbor(bias, -1.0).rgb;
	} else if ((CanScoot(-bias, 0.0, bias)) && (!CanFallDown(-bias, 0.0)) && (!CanTumble(-bias, 0.0, bias)) && (!CanTumble(-bias, 0.0, -bias))) {
		// Sand scoots sideways sometimes
		me.rgb = neighbor(-bias, 0.0).rgb;
	} else if ((CanScoot(bias, 0.0, -bias)) && (!CanFallDown(bias, 0.0)) && (!CanTumble(bias, 0.0, bias)) && (!CanTumble(bias, 0.0, -bias))) {
		// Sand scoots sideways sometimes
		me.rgb = neighbor(bias, 0.0).rgb;
	} else if ((me.rgb != blank) && (gl_FragCoord.y <= 1.0)) {
		// Sand on the bottom pixel can't tumble any more; stay still
	} else if ((me.rgb != blank) && (!CanFallDown(0.0, 0.0)) && (!CanTumble(0.0, 0.0, bias)) && (!CanTumble(0.0, 0.0, -bias)) && (!CanScoot(0.0, 0.0, bias)) && (!CanScoot(0.0, 0.0, -bias))) {
		// Sand with nowhere to go stays put
	} else {
		me.rgb = blank;
	}

	gl_FragColor = me;
}

