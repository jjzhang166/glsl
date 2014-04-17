#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//~~~~~~~~ by @greweb

vec2 lineSplitter (vec2 p, float lines, float intensity) {
	float parity = 0.;
	if(fract(p.y*lines)>0.5) parity=1.; else parity=-1.;
	return vec2(p.x+parity*intensity, p.y);
}

//~~~~~~~~~

void main( void ) {

	vec2 p = lineSplitter( gl_FragCoord.xy / resolution.xy , 20.0, sin(time*2.0)>0.99 ? 0.1 : 0.0);
	
	vec3 color = vec3(0.0);
	
	color += vec3(p.x, 0.0, 0.0);
	color += vec3(0.0, p.x+p.y < 1.0 ? 0.0 : 1.0, 0.0);
	color += vec3(0.0, 0.0, smoothstep(0.5, 1.0, p.y));
	color += distance(p, vec2(0.5, 0.5));
	
	gl_FragColor = vec4(color, 1.0 );
}