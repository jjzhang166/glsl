// by rotwang, overlapping pixels in different sizes
// @mod* stretching
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {

	float aspect = resolution.x / resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
 	vec2 pos = unipos*2.0-1.0;//bipolar
	pos.x *= aspect;

	vec3 clr = vec3(0.0);
	for(int i=0;i<8;i++)
	{
		float n = float(i);
		vec2 pos_z = vec2(floor(abs(pos.x)*n), pos.y);
		float a = 1.0-step(0.1, rand(pos_z));
		float rr = rand(pos_z);
		float gg = rand(pos_z-n)*rr;
		float bb = rand(pos_z-n-n)*gg;
		
		vec3 clr_a = vec3(rr, gg, bb)*a*2.0;
		clr += clr_a;
	}
	
	
	gl_FragColor = vec4( clr, 1.0 );
	
}