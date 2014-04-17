#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

float boxSelect(float d, float boxMin, float boxMax, float boxSmooth) {
	return smoothstep(boxMin - boxSmooth, boxMin, d) 
		- smoothstep(boxMax, boxMax + boxSmooth, d);
}

float ring( float innerRadius, float radius, float fuzzy, vec2 p ) {
	float d = length(p);
	return smoothstep(innerRadius, innerRadius + fuzzy, d) - smoothstep( radius - fuzzy, radius, d );	
}


float shankSelect(vec2 p) {
	vec2 arcp = p;
	arcp.x -= 0.5;
	arcp.y -= 0.63;
	float topHalf = step(0.0, arcp.y);
       	float arcsel = topHalf * ring(0.10, 0.16, 0.001, arcp);
	

	vec2 lbar = p;
	lbar.x -= 0.370;
	lbar.y -= 0.54;
	float xval = 1.0 - step(0.03, abs(lbar.x));
	float yval = 1.0 - step(0.1, abs(lbar.y));
	float longbar = yval * xval;

	vec2 rbar = p;
	rbar.x -= 0.63;
	rbar.y -= 0.61;
	float xval2 = 1.0 - step(0.03, abs(rbar.x));
	float yval2 = 1.0 - step(0.03, abs(rbar.y));
	float sbar = yval2 * xval2;
	
	return longbar + arcsel + sbar;
}


void main( void ) {
	// Convert pixel coords into aspect preserving 0.0<->1.0 range

	vec2 position = gl_FragCoord.xy / vec2(resolution.x, resolution.x);
	
	// Lock body
	float bodysel = boxSelect(position.x, 0.25, 0.75, 0.001) * boxSelect(position.y, 0.20, 0.5, 0.001);

	vec2 shankPos = position;
	shankPos.y += 0.03;
	shankPos.y += 0.06 * sin(time);
	float arcsel = shankSelect(shankPos);
	
	float r = arcsel + bodysel;
	float g = 0.0;
	float b = 0.0;
	
	gl_FragColor = vec4( r, g, b, 1.0);

}