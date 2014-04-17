#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = 3.14159265;

float cubicPulse( float c, float w, float x )
{
    x = abs(x - c);
    if( x>w ) return 0.0;
    x /= w;
    return 1.0 - x*x*(3.0-2.0*x);
}
float innerCore(float r, float coreWidth){
	//return 1.0 - (r/coreWidth); 
	return 1.0 - smoothstep(coreWidth-0.05,coreWidth,r);
	return 0.0;		
}

float midCore(float r, float start, float end){
	float haloWidth = end - start; 
	float midPoint = (start+end)/2.0;

	//r -= midPoint; 
	//float distFromMidPoint = abs(r);
	//if(distFromMidPoint < 0.01){
	//	return 1.0;	
	//}
	
	float pulseWidth = 0.02 + 0.01 * sin(10.0*time); 
	return cubicPulse(r,pulseWidth,midPoint);
	
	return 0.0; 
}

float graphPattern(float r, float theta, float spacing){
	r*=spacing;
	if(fract(r)<0.05){
		return 1.0; 	
	}
	if(fract(theta*2.0+time)<sin(theta)){
		return 1.0;
	}
	return 0.0; 
	
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 centre = vec2(0.5); 
	
	float aspectRatio = resolution.x/resolution.y; 
	centre.x *= aspectRatio;
	position.x *= aspectRatio;
	float d = distance(position,centre); 
	
	vec2 offset = position - centre; 
	float theta = atan(offset.y,offset.x);
	theta = (theta+pi)/(pi*2.0);
	
	
	float finalColor = 0.0;
	finalColor += innerCore(d,0.2); 
	
	
	float activateRing = 0.0;
	if(fract(time*0.5+theta*3.0) > 0.3){
		activateRing = 1.0;	
	}
	
	finalColor += activateRing * midCore(d,0.2,0.4);
	
	gl_FragColor = vec4(finalColor);
	gl_FragColor.r += graphPattern(d,theta,20.0);
	gl_FragColor.g += theta*sin(time);
	
	
	
}