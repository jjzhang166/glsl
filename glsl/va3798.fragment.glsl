// by rotwang, overlapping pixels in different sizes.
// drifting around by @emackey
// "tunnelized" by kabuto
// rotwang: @mod* variation
// Modded by T_S=RTX1911= @rtx1911 @T_SDesignWorks
// gngbng: moblur with a little "twist"

//More blur by 0x1911(T_S)

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.1415926535;
const float TWOPI = PI*2.0;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(11.9898,78.233))) * 43758.5453);
}

vec4 render( float t ) {

	vec2 dir = vec2(0, sin(t * 0.25) * .25);
	vec2 travel = t * vec2(-0.1, 0.);
	float aspect = resolution.x / resolution.y;
	vec2 p =  ( gl_FragCoord.xy - resolution.xy*.5) / resolution.y;
	float angle = (atan(p.x, p.y)+PI)/TWOPI;
	vec2 pos1 = vec2(-.05/length(p),atan(p.y,p.x)/(2.*3.1415926));
	vec2 pos = pos1 + (pos1.x * dir.y * 3.) + dir + travel;
	
	
	vec3 clr = vec3(0.0);
	for(int i=0;i<4;i++)
	{ // can't do 5 iters w/ moblur, at least my gtx570 can't
		pos.y = fract(pos.y);
		float n = pow(5.0-float(i), 1.5)*5.;
		vec2 pos_z = floor(pos*n);
		float a = 1.25-step(0.125, rand(pos_z))*angle*2.5;
		float rr = rand(pos_z)*a;
		float gg = rand(pos_z+n)*a;
		float bb = rand(pos_z+n+n)*a;
		
		vec3 clr_a = vec3(rr, gg, bb);
		clr += clr_a*clr_a/1.0;
		pos += dir + travel;
	}
	
	clr = sqrt(clr);
	clr *= -pos1.x;
	clr += length(pos1)*vec3(0.9, 0.3,0.2);
	clr *= 2.5-length(p*p);
	return vec4( clr, 1.0 );
	
}

void main(void) {
	vec4 final = vec4(0);
	for(float t = 0.; t < 8.; t++) {
		final += render(time + t * 0.005);
	}
	gl_FragColor = final / 10.;
}