// by rotwang, overlapping pixels in different sizes

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
		float n = pow(1.0+float(i), 2.0);
		vec2 pos_z = floor(pos*n);
		float a = 1.0-step(0.1, rand(pos_z));
		float rr = rand(pos_z)*a;
		float gg = rand(pos_z+n)*a;
		float bb = rand(pos_z+n+n)*a;
		
		vec3 clr_a = vec3(rr, gg, bb);
		clr += clr_a/2.0;
	}
	
	
	gl_FragColor = vec4( clr, 1.0 );
	
}