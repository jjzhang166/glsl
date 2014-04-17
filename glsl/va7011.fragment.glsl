#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float pi = 3.1415927;


float random(in float a, in float b) { return fract((cos(dot(vec2(a,b) ,vec2(12.9898,78.233))) * 43758.5453)); }
float cerp(in float a, in float b, in float c) {
	float f = (1. - cos(c * pi)) * .5;
	return (a*(1.-f)+b*f);
}


float snoise(in float x, in float y) {
	float i = floor(x), j = floor(y);
	float u = x-i, v = y-j;
	
	float a = random( i   , j   );
	float b = random( i+1., j   );
	float c = random( i   , j+1.);
	float d = random( i+1., j+1.);
	
	float v1 = cerp(a, b, u);
	float v2 = cerp(c, d, u);
	
	
	return cerp(v1, v2, v);
}

float pnoise(in float x, in float y) {
	vec2 pos = vec2(x, y);
	float c = snoise(pos.x, pos.y)*.5;
	float f = 3.131; 	
	float ff = f;
	
	float p = 0.3733; 	
	float pp = p;
	
	for(int i = 0; i < 3; i++) {
		c += snoise(pos.x*ff, pos.y * ff) * pp;
		ff *= f;
		pp *= p;
	}
	
	c /= .05*sqrt(x*x+y*y);
	
	return c;
}

void main( void ) {
	vec2 pos = -1. + 2. *( gl_FragCoord.xy / resolution.xy );
	vec2 pos1 = pos * 10.;
	vec2 pos2 = pos * 20.;
	vec2 pos3 = pos * 40.;
	pos *= 30.;
	pos1 += vec2(sin(time), cos(time)) * 4.;
	pos2 += vec2(cos(time), sin(time)) * 8.;
	pos3 += vec2(cos(time), cos(time)) * 12.;

	vec4 color = vec4(pnoise(pos1.x, pos1.y), pnoise(pos2.x, pos2.y), pnoise(pos3.x ,pos3.y), 1);
	color.xyz = cross(color.xyz, vec3(random(pos.x, pos.y), random(pos.y, pos.x), .5));
	color.xyz += vec3(pnoise(pos.x, pos.y)) * .5;
	
	gl_FragColor = color;
}

