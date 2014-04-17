#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float ring(vec2 pos, vec2 center){
	return length(pos - center);
}

void main( void ) {
	
	vec2 position = gl_FragCoord.xy / resolution.y - vec2(resolution.x / resolution.y / 2.0, 0.5);
	
	float radius = ring(position, vec2(0.0, 0.0));
	float depth = 1.0 / radius;
	float angle = atan(position.y, position.x);
	vec3 pos = vec3(position*depth, depth);

	
	vec3 color = vec3(0, 0, 0);
	
	if(mod(floor(depth + time), 2.0) == 0.0)
		color = vec3(0.9, 0.9, 0.9);
	else
		color = vec3(0.2, 0.2, 0.2);
	
	vec3 lightpos = vec3(0, 0.4, mod(floor(depth), 10.0));
	
	color += 0.5 / pow(length(pos - lightpos), 2.0);
	
	float t = time;
	float a = atan(position.x, sin(position.y*2.0)*4.0);
	a += t*0.4;
	a = fract(a) + sin(t*1.0)*0.1;
	a = float(a > .3) + float(a < .2);
	
	gl_FragColor = vec4(a*color, 1.0 );

}