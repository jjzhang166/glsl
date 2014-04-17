#ifdef GL_ES
precision mediump float;
#endif

//Just playing with distance fields
//@Tims mint.

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// This is the distance function. 
float TwoDDistFunc( float a, float b)
{

	return a - 1.0 + ( 0.5 * cos( (3.0 * b) + (2.0 * a * a) ) );
}

void main( void ) {

	float zoom = 0.008 - (2.0 * mouse.y/200.0);
	vec2 offsetpos = vec2(1500.0, 0.0);
	vec2 position = /*(*/ abs(gl_FragCoord.xy - offsetpos) * zoom;// - mouse * 5.8;;/// resolution.xy ) 

	float d  = abs(TwoDDistFunc( position.x, position.y));
	float d1 = abs(TwoDDistFunc( position.y, position.x));
	float d2 = abs(TwoDDistFunc( d, d1));
	
	//Creates some very odd white noise.
	float d3 = abs(TwoDDistFunc( sin(time * d2), cos(time * d2)));
	
	//Some looping effect... boring.
	float d4 = abs(TwoDDistFunc( abs(atan(time)) * d2,  d2));
	gl_FragColor = vec4(d4,d4,d4,0.0);

}