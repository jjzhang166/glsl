#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float PI = 3.14159265;

float cubicPulse( float c, float w, float x )
{
    x = abs(x - c);
    if( x>w ) return 0.0;
    x /= w;
    return 1.0 - x*x*(3.0-2.0*x);
}


// From Robert Penner
float punch(float amplitude, float value){
		float s = 9.0;
		if (value <= 0.0){
			return 0.0;
		}
		if (value >= 1.0){
			return 0.0;
		}
		float period = 1.0 * 0.3;
		s = period / (2.0 * PI) * asin(0.0);
		return (amplitude * pow(2.0, -10.0 * value) * sin((value * 1.0 - s) * (2.0 * PI) / period));
}

float timeElapsed(){
	float HIT_PERIOD = 5.0; 
	return fract(time/HIT_PERIOD)*HIT_PERIOD;
}

float timeEnvelope(float _timeElapsed, float effectLength){
	return punch(1.0,_timeElapsed/effectLength); 
}


void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position = position*2.0 - vec2(1.0);
		

	float EFFECT_CENTRE = 0.0;//mouse.x*2.0 -1.0; 
	float EFFECT_TIME_LENGTH = 2.0; 	
	float EFFECT_WIDTH = 0.5;
	float EFFECT_MULTIPLIER = 4.0; 
	
	/////////////////////////////////////////////
	// Time Elapsed since hit 
	float elapsed = timeElapsed(); 
	
	/////////////////////////////////////////////////
	// Calculate the fade effect in time 			
	float expandingPeriod = EFFECT_TIME_LENGTH - elapsed; 
	float lineY = sin(elapsed*2.0)*cos(position.x * 20.0 * expandingPeriod); 
		
	
	/////////////////////////////////////////////////
	// Calculate the fade effect in distance 
	// Restrain the overall effect to an envelope 			
	float geometryEnvelope = cubicPulse(EFFECT_CENTRE,EFFECT_WIDTH,position.x);	
	//////////////////////////////////////////////////
	// Final Line Multiplier 	
	lineY *= EFFECT_MULTIPLIER * geometryEnvelope *timeEnvelope(elapsed,EFFECT_TIME_LENGTH); 
	
	// Just keep the line 
	if(abs(position.y-lineY)>0.005){
		//gl_FragColor = vec4(0,EFFECT_TIME_LENGTH-elapsed,0,1); 
	} else {
		gl_FragColor = vec4(1,0,elapsed,1);
	}

}