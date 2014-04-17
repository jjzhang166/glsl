#ifdef GL_ES
precision mediump float;
#endif

// fucking hoover

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float bob(vec2 p, vec2 t, float r) {
	if (length(t-p) < r) {
		return 0.2;
	}
	return 0.0;
}

void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution.xy;
	float a = resolution.x/resolution.y;
	p.x = p.x*a;
	vec2 m = vec2(mouse.x*a, mouse.y);
	//vec3 col = vec3(bob(p, m, 0.1));
	vec3 col = vec3(0.0);
	for (float i=0.0; i < 5.0; i+=0.1) {
	  col += vec3(bob(p, vec2(0.5*cos(2.0*i*sin(time)*cos(time+i*0.1))+m.x-0.5, 0.3*sin(i*sin(time)-cos(time+i))+m.y), 0.1));	
	}
	gl_FragColor = vec4(vec3(col), 1.0);
//	gl_FragColor = vec4(vec3(bob(p, m, 0.05*(1.5+sin(time)))), 1.0);
}