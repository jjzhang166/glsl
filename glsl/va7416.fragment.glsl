#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float twoPI;
float timex;

vec2 transform_stretch(vec2 position, vec2 center, float factor){
	vec2 d = position - center;
	position += d * (factor - 1.0);
	return position;
}

vec2 transform_rotate(vec2 position, vec2 center, float alpha){
	vec2 d = position - center;
	d = vec2(d.x * cos(alpha) + d.y * sin(alpha), -d.x * sin(alpha) + d.y * cos(alpha));
	return center + d;
}

vec2 transform_N_polygon(vec2 position, vec2 center, int N, float factor){
	float n = float(N);
	position -= center;
	float angle = atan(position.y, position.x);
	float sectionangle = (floor(angle * n / twoPI) + 0.5 ) * twoPI / n;
	vec2  sectiondirection = vec2(cos(sectionangle), sin(sectionangle));
	vec2  d = sectiondirection * dot(position.xy, sectiondirection.xy);
	vec2 d1 = d * factor;
	position -= d1 - d;
	return position.xy + center.xy;
}

void main( void ) {
	twoPI = 6.2831853;
	timex = time*5.0+1000.0;
	vec2 position = ( (gl_FragCoord.xy - resolution.xy / 2.0) / resolution.yy ) * 2.0;
	vec2 mouse = mouse.xy * 2.0 - 1.0;
	mouse.x *= resolution.x/resolution.y;
	float angle = atan(position.y, position.x);
	
	position = transform_rotate(position, vec2(0.0), timex*0.2 + length(position)*sin(timex*0.2)*twoPI/4.0);
	position = transform_N_polygon(position, vec2(0.0), 6, 1.7);
	
	float r = length(position) + sin(angle*10.0 + timex)*0.02;
	gl_FragColor = vec4( fract( ( ( sin(vec3(0.2,1.4,2.3) * 0.00001 * timex) + vec3(1.2,1.8,2.2) * 0.00001 * timex  ) * vec3(3.0,11.0,15.0) )*( r + timex * 0.05 + sin(timex*0.1) ) ), 1.0 );
}