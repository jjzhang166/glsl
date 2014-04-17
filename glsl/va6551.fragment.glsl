#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec3 color = vec3(0,0,0);
	float sq = 62.0;
	
	vec2 pos = mouse * resolution;
	

	
	if (   gl_FragCoord.x > pos.x - sq/2.0
	    && gl_FragCoord.x < pos.x + sq/2.0
	    && gl_FragCoord.y < pos.y + sq/2.0
	    && gl_FragCoord.y > pos.y - sq/2.0) color = vec3(1,1,1);
	
	gl_FragColor = vec4(color, 1.0 );
}