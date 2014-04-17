//rand lines

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec3 c = vec3(1.);
	vec2 p = gl_FragCoord.xy;
	p += vec2(sin(gl_FragCoord.x)*10.0*sin(time*0.05),gl_FragCoord.y);
	if(int( p.x-10.*float(int(p.x/10.))) > 7) 
		c=vec3(0.);
	gl_FragColor = vec4(c, 1.0);
}