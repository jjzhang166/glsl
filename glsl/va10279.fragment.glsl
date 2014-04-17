#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 grid(vec2 v,float gs,float lr)//position, grid size, line radius
{
	float b;
	
	float px = mod(v.x*0.5,gs);
	float py = mod(v.y*0.5,gs);
	float gx = min(smoothstep(0.,lr,px),smoothstep(gs,gs-lr,px));
	float gy = min(smoothstep(0.,lr,py),smoothstep(gs,gs-lr,py));
	
	b = min(gx,gy);
	
	return vec3(b);
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy );

	float color = grid(p,32.,2.).x;
	
	gl_FragColor = vec4( vec3( color ), 1.0 );

}