// First test in the GLSL sandbox
// by peer (@albertojaspe)

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	//vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec2 posR = vec2((sin(time*2.0)+1.0)/2.0, (cos(time*3.0)+1.0)/2.0);
	float disR = distance(position, posR)*3.0;
	float r = 1.0-disR;

	vec2 posG = vec2((sin((time+2.0)*1.0)+1.0)/2.0, (cos((time+2.0)*3.0)+1.0)/2.0);
	float disG = distance(position, posG)*3.0;
	float g = 1.0-disG;
	
	vec2 posB = vec2((sin((time+4.0)*2.5)+1.0)/2.0, (cos((time+5.0)*2.0)+1.0)/2.0);
	float disB = distance(position, posB)*3.0;
	float b = 1.0-disB;
	
	float distRG = distance(posR, posG);
	float distRB = distance(posR, posB);
	float distGB = distance(posG, posB);
	float limit = 0.3;
	
	if(distRG < limit) {
		float fact = 1.0 - (distRG/limit)*(distRG/limit);
		r += fact;
		g += fact;
	}
	
	if(distRB < limit) {
		float fact = 1.0 - (distRB/limit)*(distRB/limit);
		r += fact;
		b += fact;
	}
	
	if(distGB < limit) {
		float fact = 1.0 - (distGB/limit)*(distGB/limit);
		g += fact;
		b += fact;
	}
	vec4 color = vec4(r,g,b,1);
	//color = noise4(position);
	gl_FragColor = color;
}