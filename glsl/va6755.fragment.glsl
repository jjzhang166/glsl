#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

bool inRect(vec2 center, float size, vec2 pos) {
	if(pos.y > center - (size / 2.) && pos.y < center + (size / 2.) && pos.x > center - (size / 2.) && pos.x < center + (size / 2.)) {
		return true;
	}
	return false;
}

void main( void ) {
	vec3 col = vec3(0.0,0.0,0.0);
	vec2 position = gl_FragCoord.xy;
	vec2 center = resolution / 8.;
	float size = 30.;
	
	for( float i = 1.; i < 10.; i++) {
		size = size / i;
		if(inRect(center + (vec2(size * 2., size * 2.)), size, position)) {
			col.x = 1.;	
		}
	}

    	gl_FragColor = vec4(col, 1.0);

}