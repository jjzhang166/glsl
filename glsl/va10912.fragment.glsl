#ifdef GL_ES
precision mediump float;
#endif
	
	uniform vec2 resolution;
	uniform vec2 mouse;
	
void main() {

	vec2 pos =  vec2( gl_FragCoord.x, gl_FragCoord.y ) ;
	vec2 m = mouse.xy*resolution.xy;
	
	vec3 c = vec3(pos.x/resolution.x, pos.y/resolution.y, 0.3);
	float d = 0.01*distance(pos,m);
	c += vec3(c.x/d,c.y/d,0.3);
	gl_FragColor = vec4(c, 1.0);
}	