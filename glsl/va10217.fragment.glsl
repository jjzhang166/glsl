#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float WIDTH = 63.0;
const float BORDER = 0.0;

float pipeColor(float halfDist) {
	return 1.0 - (0.8 * smoothstep(0.0, WIDTH, halfDist));
}

float bar(float x) {
	float val = 0.0;
	x = abs(x);
	if (x > WIDTH + BORDER) {
		val = -1.0;
	} else if (x > WIDTH) {
		val = 0.0;
	} else {
		val = pipeColor(x);
	}
	return val;		
}

float halfBar(float b, float chop) {
	if (chop > 0.0) {
		return bar(b);
	} else {
		return -1.0;
	}
}


void main( void ) {

	vec2 position = gl_FragCoord.xy;

	position.x -= resolution.x/2.0;
	position.y -= resolution.y/2.0;

	float vColor;
	
	// cross
	// vColor = max(bar(position.x), bar(position.y));

	// corner (up + right)
	if ((position.x < WIDTH) && (position.y < WIDTH)) {
		float dx = position.x - WIDTH;
		float dy = position.y - WIDTH;
           	float dist = sqrt(dx*dx + dy*dy);
		if (dist > (WIDTH * 2.0 + BORDER)) {
			vColor = -1.0;
		} else if (dist > (WIDTH * 2.0)) {
			vColor = 0.0;
		} else {
	   		vColor = pipeColor(abs(dist - WIDTH));
		}
	} else {
	   vColor = max(halfBar(position.x, position.y), halfBar(position.y, position.x));
	}
	
	// tee (no left)
	//vColor = max(bar(position.x), halfBar(position.y, position.x));
	
	// bar (vert)
	//vColor = bar(position.x);
	
		
	if (vColor < 0.0) {
		discard; // gl_FragColor = vec4(0.3, 0.4, 0.6, 1.0);
	} else {
		gl_FragColor = vec4( vec3( vColor, vColor, vColor), vColor );
	}

}