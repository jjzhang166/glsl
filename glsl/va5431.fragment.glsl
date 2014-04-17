#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.141592;

void main( void ) {
	
	//position 0-1 arasi deger verir
	vec2 p = (gl_FragCoord.xy / resolution.xy ) * 2. - 1.;
	p.x *= resolution.x / resolution.y;
	
	//float colorR = sin(PI);
	//float colorB = acos(PI * time);
	float colorR = 0.0;
	float colorB = 0.0;
	
	
	if((p.x+200.) * (p.x) + p.y * p.y < abs(sin(time))/2.){ //inside of circle

		colorR = 1. - ((p.x)  * (p.x) + p.y * p.y) * 1./abs(sin(time))/2.;
	
	}else if((p.x-200.) * (p.x) + p.y * p.y < abs(sin(time))/3.){ //inside of circle
		
		colorR = 1. - ((p.x) * (p.x) + p.y * p.y) * 1./abs(sin(time));
	
	}else{ //outside of circle
	
		colorB =1. - (p.x * p.x + p.y * p.y) * .2;
	
	}
	
	
	gl_FragColor = vec4(colorR, colorB, 0.0, 0.0);
	
	/*
	float color = 0.0;
	color += atan( position.x + 1.0 * tan( time / 15.0 ) * 20.0 ) + cos( position.y * cos( time / 1.0 ) * 6.0 );
	color *= atan( position.y * sin( time / 1.0 ) * 1230.0 ) + cos( position.x * sin( time / 2.0 ) * 8.0 );
	color += tan( position.x * sin( time / 20.0 ) * 8.0 ) + cos( position.y * sin( time / 3.0 ) * 80.0 );
	color += tan( time / 40.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color,color * 0.9, sin( color + time / 3.0 ) * 0.9 ), 0.0 );
*/
}