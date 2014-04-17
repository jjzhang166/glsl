#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec2 center;
float c, f, d, beat;
float a;
float b;
float size;
float t;
float pii = 3.141592653589;
float ang, kulma, dist;
float px, py, pz, h;
float sx, sy;
int i;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {
	t = time / 30.0;
	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	c = 0.0;
	
	ang = t *2.0 * 2.0 * pii;
	size = (2.0-(sin(ang/2.0)))/2.0-(pos.y*0.4);
	b = 1.0-(size/2.0);


	beat = pow(abs(sin( ang*8.0 )), 8.0) * 0.25;

	c = sin( pos.x*110.0*size+ang+beat )+(cos(pos.y*200.0*size+beat*4.0)*1.3);
	//c = sin(pos.x * 100.0);
	//b = sin(pos.y * 150.0);
	px = 0.5;
	py = 0.5 - (abs(sin( ang*2.0 )*384.0));

	d = (1.0-pos.y)*c;
	
	gl_FragColor = vec4((c*0.9)*b+beat, (d*0.5)*b-beat, (c-(d*0.65))*b+beat, 1.0); 


}