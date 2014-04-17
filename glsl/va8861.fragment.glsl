#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float distance(vec2 pos){
	float x = pos.x * 9990.1 + time;
	float height = sin(x) / 5.0;
	
	float angle;
	angle = atan(1.0 / cos(x));

	return abs(height - pos.y) - 0.01 - abs(0.05*(cos(time*2.0)/2.0 + 1.0) / sin(angle));
}

void main( void ) {
	vec2 pos = gl_FragCoord.xy / resolution - vec2(0.5, 0.5);
	float dist = distance(pos);
	
	vec3 color = vec3(0.4 + 0.8 * abs(sin(pos.x - time/1.5)), 0.5, 0);

	if(dist < 0.0){
		color *= log(-dist * (42.0 + abs(cos(time*7.0))*100.0 + abs(sin(time*12354.0)) * 33.0));
	}else{
		color = vec3(0,0,0);
	}
	
	gl_FragColor = vec4(color, 1.0 );
}