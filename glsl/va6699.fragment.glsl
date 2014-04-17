#ifdef GL_ES
precision mediump float;
#endif

// doubled by @hintz
// mouse added by anonymous.

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	p -= vec2(0.5);
	p.x *= resolution.x / resolution.y;
	
	vec2 p2 = p - (mouse * 2. - vec2(1.));
	
	p *= sin(time) + 2.0;
	p.x += sin(time * 1.0);
	p.y += sin(time * 1.101);
	
	
	p2 *= sin(time) + 2.1;
	
	
	
	float x = 2.0 + fract(length(p*.5))*6.0;
	float x2 = 2.0 + fract(length(p2*.5))*6.0;
	
	float r = -(clamp(x-3.0,0.0,1.0)+clamp(-x+1.0,0.0,1.0))+1.0 -(clamp(x-9.0,0.0,1.0)+clamp(-x+7.0,0.0,1.0))+1.0;
	float g = -(clamp(x-5.0,0.0,1.0)+clamp(-x+3.0,0.0,1.0))+1.0;
	float b = -(clamp(x-7.0,0.0,1.0)+clamp(-x+5.0,0.0,1.0))+1.0;
	
	float r2 = -(clamp(x2-3.0,0.0,1.0)+clamp(-x2+1.0,0.0,1.0))+1.0 -(clamp(x2-9.0,0.0,1.0)+clamp(-x2+7.0,0.0,1.0))+1.0;
	float g2 = -(clamp(x2-5.0,0.0,1.0)+clamp(-x2+3.0,0.0,1.0))+1.0;
	float b2 = -(clamp(x2-7.0,0.0,1.0)+clamp(-x2+5.0,0.0,1.0))+1.0;
	
	
	gl_FragColor = vec4( 0.5 * vec3( r+r2, g+g2 , b+b2), 1.0 );

}