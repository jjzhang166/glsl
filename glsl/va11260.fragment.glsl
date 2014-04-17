#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


bool dansLeCercle(vec2 point, vec2 centre, float rayon) {

	return distance(point, centre) <  rayon;
}

vec2 reproduis(vec2 position) {
	return mod(position*4.0, 1.0);
}


void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float color = float(dansLeCercle(reproduis(position), vec2(cos(time)/4.0+0.5, (sin(time*5.0)/4.0)+0.5), 0.1));
	gl_FragColor = vec4(color, 0.0, (sin(time)/2.0+0.5)*color, 0.0);
	
}




