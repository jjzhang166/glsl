#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define STEP 0.2 // Circle amount
#define R_STEP .1 // Subdivision Amount

float color(vec2 p){
	
	if(mod(p.x, R_STEP) < R_STEP * 0.91234) // Subdivision Linewidth
	{
		p.y += STEP * .5; // Black Subdivisions position
	}
	if(mod(p.y, STEP) < STEP * time*(0.0006)) // Circle LineWidth
	{
		return 1.0;
	}
	else{
		return 0.0;
	}
}


vec2 transform(vec2 p){
	return vec2(atan(p.y, p.x) + time * 0.5, 1.0 / length(p) + time * 0.3);
}

void main( void ) {

	vec2 pos = (gl_FragCoord.xy * 2.0 - resolution) / resolution.y ;

		
	gl_FragColor = vec4(color(transform(pos))) - max((1.0 - dot(pos, pos)), 0.0);

}