// by rotwang, overlapping pixels in different sizes.

// drifting around by @emackey

// "tunnelized" by kabuto
// warptunneled by psonice

// emackey - added "abs()" to prevent pow() of negative numbers, not allowed on all GPUs.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(11.9898,78.233))) * 43758.5453);
}

void main( void ) {

	vec2 dir = vec2(0, sin(time * 0.1) * .15);
	vec2 travel = time * vec2(-0.04, 0) + vec2(100.0, 0.0);
	float aspect = resolution.x / resolution.y;
	vec2 pos1 =  ( gl_FragCoord.xy - resolution.xy*.5) / resolution.y;
	pos1 = vec2(-.1/length(pos1),atan(pos1.y,pos1.x)/(2.*3.1415926));
	vec2 pos = pos1 + dir + travel;

	vec3 clr = vec3(0.0);
	for(int i=0;i<12;i++)
	{
		pos.y = fract(pos.y);
		float n = pow(abs(10.0-float(i)), 2.50)*10.;
		vec2 pos_z = floor(pos*n);
		pos_z = mix(pos_z, pos*n*2., .00004 * float(i*i+5) );
		float a = 1.0-step(0.2, rand(pos_z));
		float rr = rand(pos_z)*a;
		float gg = rand(pos_z+n)*a;
		float bb = rand(pos_z+n+n)*a;
		
		vec3 clr_a = vec3(rr, gg, bb) * float(i + 4) * 0.125;
		clr += clr_a*clr_a/4.0;
		clr *= clr_a + 1.;
		pos += dir + travel;
	}
	
	
	gl_FragColor = vec4( sqrt(clr)/(1.-pos1.x*2.), 1.0 );
	
}