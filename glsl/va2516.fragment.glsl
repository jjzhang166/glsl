/*
Do you see green and blue spirals?
It's a optical illusion.
This code is drawing purple and orange spirals on green back ground.
Let's move mouse cursor or change "bgcol".

move mouse cursor to right : remove purple spiral
move mouse cursor to bottom : remove orange spiral

original image : http://www.psy.ritsumei.ac.jp/~akitaoka/color-e.html
*/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI2 6.28318531
float logspiral(float sita, float r, float phi, float n) {
    sita += log(r) * phi;
    return fract(sita * n);
}

void main( void ) {
	vec2 position = (gl_FragCoord.xy - resolution * 0.5) / resolution.yy;
	float angle = atan(position.y, position.x) / PI2 + 0.5 + time * 0.005;
	float radius = length(position);
	
	float bigphi = 9.61803399;
	bool s1 = (mouse.y < 0.25)? false : logspiral(angle, radius, bigphi, 1.0) > 0.25;
	bool s2 = (mouse.x > 0.75)? false : logspiral(angle + 0.25 * PI2, radius, bigphi, 1.0) > 0.25;
	bool s3 = logspiral(angle, radius, -0.2, 64.0) > 0.5;
	
	// background green color
	vec3 bgcol = vec3(0.0, 1.0, 0.6);
	
	// orange or purple spiral color
	vec3 col = bgcol;
	col = (s1 && s3)?  vec3(1.0, 0.6, 0.0) : col;
	col = (s2 && !s3)? vec3(1.0, 0.0, 1.0) : col;
	
	float m = 1.0;//exp(-10.0 * pow(mouse.x, 12.0));
	gl_FragColor = vec4(mix(bgcol, col, m), 1.0);
}