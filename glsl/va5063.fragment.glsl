precision mediump float;

uniform float time;
uniform vec2 resolution;

vec3 getpix( vec2 pos ) {
	float theta = exp(cos(sin(pos.y/pos.x)*sin(pos.x/pos.y)+time*0.2));
	float rad = exp(sqrt(pos.x*pos.x + pos.y*pos.y));
	vec3 col = vec3(0.8,1.0,0.8);
	col *= smoothstep(rad, 0.0,1.0);
	
	vec3 streaks = vec3(0.8,0.1,1.0);
	col = mix(col, streaks, 0.4*sin(8.0*theta));
	return col;
}

void main ( void ) {
	vec2 pos = ( gl_FragCoord.xy / resolution.yy ) - vec2(1.0,0.5);
	vec3 col = vec3(0.0,0.0,0.0);
	vec2 offset;
	float dist = 0.25-(sin(time)+time*0.02)*0.05;
	for (float i=-1.0; i<2.0; i++) {
		for (float j=-1.0; j<2.0; j++) {
			offset = vec2(i*dist, j*dist);
			col += getpix(pos + offset)/9.0;
				}
	}
	gl_FragColor = vec4(col,1.0);
}