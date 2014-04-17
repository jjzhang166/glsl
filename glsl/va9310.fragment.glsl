#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float square(vec2 position, vec2 center, float radius) {
	vec2 d = position - center;
	if(abs(d.x)<radius && abs(d.y)<radius)
		return clamp(1.0+cos(d.x*100.0)+cos(d.y*120.0), 0.0, 1.0);
	return 0.0;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - mouse;

	vec3 color = vec3(0.0);
	
	color = vec3(square(position, vec2(0.0, 0.0), 0.1),0,0);
	color += square(position, vec2(cos(time) * 0.3, sin(time)*0.3), 0.03);
	
	gl_FragColor = vec4( color, 1.0 );

}