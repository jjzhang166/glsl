#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec2 m = mouse;
	vec2 op = vec2(gl_FragCoord.x,gl_FragCoord.y);
	float dx = ((resolution.x)/2.0) - op.x + m.x;
	float dy = ((resolution.y)/2.0) - op.y + m.y;
	float dist = sin(sqrt(dx*dx + dy*dy)/resolution.x);
	dist += sin(op.x);
		
	float r = sin((dist+1.1*mouse.x)*(time*1.0*sin(dist)));
	float g = sin((dist*1.1*mouse.y)*(time*1.0));
	float b = sin((dist*1.1*mouse.y*mouse.x)*(time*1.0));
	
	r *= 1.0 - dist;
	g *= 1.0 - dist;
	b *= 1.0 - dist;
	b= 0.3;
	vec3 rgb = vec3(r,g,b);
	

	
	gl_FragColor = vec4( rgb, 1.0 );

}