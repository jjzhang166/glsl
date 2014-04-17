// by rotwang
// mod
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float PI = 3.14159;

float rand(vec2 co){
// implementation found at: lumina.sourceforge.net/Tutorials/Noise.html
return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec2 r(vec2 p, float r) {
	mat2 mr = mat2(
		0.3*p.x*sin(time),
		0.1*sin(time),
		
		0.3,
		p.x+0.
	);
	return mr * p * 10.1;
}

float curve(float x)
{
	float f = 4.0;
	return max(min( cos(x*f*PI), 0.5),0.0);
}

void main( void ) {
	
	// Normalize and center coord
	vec2 pos = (gl_FragCoord.xy / resolution.y);
	pos -= vec2((resolution.x / resolution.y) / 2.0, 0.5);
	float t=1.0;
	float amplitude = 0.5;
				     
	pos=r(pos,time);
	
	float y;
	y=curve(pos.x+sin(time)/5.)+cos(time)/9.;
	//y=curve(pos.x);
	y-=0.25;
	
	float anim = 1.;
	anim=rand(pos);
	
	float shade = 1.0 / (exp(abs(y*anim - pos.y) * 200.0*abs(pos.y)));
	
	shade = shade * abs(sin(time/200.*pos.x+pos.x-pos.y));
	
	gl_FragColor = vec4( vec3( shade * 0.2, shade * 0.66, shade * 1.0 ), 1.0 );

}