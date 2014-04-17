// by rotwang

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float PI = 3.1415926535;

float rand(vec2 co){
// implementation found at: lumina.sourceforge.net/Tutorials/Noise.html
return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float curve(float x)
{
	float f = 4.0;
	return max(min( cos(x*f*PI), 0.5),0.0);
}

float smooth_curve( float x )
{
    float f = curve( x );
	
    return smoothstep( 0.33, 0.66, f );
}

void main( void ) {
	
	// Normalize and center coord
	vec2 pos = (gl_FragCoord.xy / resolution.y);
	pos -= vec2((resolution.x / resolution.y) / 2.0, 0.5);
	float t=1.0;
	float amplitude = 0.5;
				     
				     
	float y = smooth_curve(pos.x)*amplitude;
	y-=0.25;
	float anim = rand(pos * time);
	
	float shade = 1.0 / (exp(abs(y*anim - pos.y) * 200.0*abs(pos.y)));
	
	
	gl_FragColor = vec4( vec3( shade * 0.2, shade * 0.66, shade * 1.0 ), 1.0 );

}