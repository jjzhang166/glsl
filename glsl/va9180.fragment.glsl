#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 rgbFromHue(in float h) {
	h = fract(h)*6.0;
	
	return vec3((1.0 - clamp(h-1.0,0.0,1.0)) + clamp(h-4.0,0.0,1.0),
		clamp(h,0.0,1.0) - clamp(h-3.0,0.0,1.0),
		clamp(h-2.0,0.0,1.0) - clamp(h-5.0,0.0,1.0));
}

#define step 400

void main( void ) {

	float iter = 0.0;

	vec2  zomminCoord;
	float zoomFactor;
	
	
	
	const vec2 P0 = vec2(.098735,.957450); 
	const vec2 P1 = vec2(1.7484275,.0100695); 
	const vec2 P2 = vec2(1.372495,.0850);;
	const vec2 P3 = vec2(.74397,-.1483);
	const vec2 P4 = vec2(0.745411,-0.1);
	
	float timeline0 = fract(time*0.0045)*5.0;
	
	if (timeline0 < 1.0){
		zomminCoord  = P0;
	} else if (timeline0 < 2.0) {
		zomminCoord  = P1;
	} else if (timeline0 < 3.0) {
		zomminCoord  = P2;
	} else if (timeline0 < 4.0) {
		zomminCoord  = P3;
	} else {
		zomminCoord  = P4;
	}
	
	
	float timeline1 = mod(timeline0,1.0)*2.0;
		
	const float z0 = -0.5;
	const float z1 = 4.75;
	
	float keyF0 = smoothstep(.0,1.0,timeline1);
	float keyF1 = smoothstep(1.0,2.0,timeline1);
	float keyF2 = smoothstep(2.0,3.0,timeline1);
	
	float kF0 = 1.0 - keyF0;
	float kF1 = keyF0-keyF1;
	float kF2 = keyF1;

	zoomFactor = kF0 * z0 +
		     kF1 * z1 +
		     kF2 * z0;
	
	zoomFactor = 1.0/pow(10.0,zoomFactor);
		
	vec2 icoord = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y, resolution.x) * 2.0;
	
	float cosa = cos(time*0.25);
	float sina = sin(time*0.25);
	
	icoord = vec2(icoord.x*cosa + icoord.y*sina, icoord.x*sina - icoord.y*cosa);
	vec2 coord = (icoord*zoomFactor - zomminCoord);
	
	vec2 z = vec2(0.0,0.0);
	
	for(int i=0; i < step; i++) {
		
		iter += 1.01;
		
		z = vec2(z.x*z.x-z.y*z.y, 2.0*z.x*z.y) + coord;
		
		if (z.x*z.x + z.y*z.y > 4.1) {
			gl_FragColor = vec4(rgbFromHue((3.0+cos(time*0.0125))*iter/float(step))*0.5 +
					    rgbFromHue(cos(time*0.0213))*0.5
					    , 1.0 );
			return;
		}

	}
	
	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0 );
}