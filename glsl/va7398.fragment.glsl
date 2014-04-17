#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

int cmpPixelR(vec2 abs_position) {
	vec2 position = ( abs_position / resolution.xy );
	vec4 color = texture2D(backbuffer, position);
	if(color.x > 0.5) {
		return 1;
	}	
	return 0;
}
void cultureR() {
	vec2 abs_position = gl_FragCoord.xy;
	
	int isAlive = cmpPixelR(abs_position);
	int numAround = 0;
	
	numAround += cmpPixelR(gl_FragCoord.xy + vec2(1.0, 0.0));
	numAround += cmpPixelR(gl_FragCoord.xy + vec2(0.0, 1.0));
	numAround += cmpPixelR(gl_FragCoord.xy + vec2(1.0, 1.0));
	numAround += cmpPixelR(gl_FragCoord.xy + vec2(-1.0, 0.0));
	numAround += cmpPixelR(gl_FragCoord.xy + vec2(0.0, -1.0));
	numAround += cmpPixelR(gl_FragCoord.xy + vec2(-1.0, -1.0));
	numAround += cmpPixelR(gl_FragCoord.xy + vec2(1.0, -1.0));
	numAround += cmpPixelR(gl_FragCoord.xy + vec2(-1.0, 1.0));
	
	
	if(numAround < 2) {
		isAlive = 0;
	} else if(numAround > 3) {
		isAlive = 0;
	} else if(numAround == 3) {
		isAlive = 1;
	}
	
	if(isAlive == 1) {
		gl_FragColor.x = 1.0;
	} else {
		gl_FragColor.x = 0.0;
	}
}

int cmpPixelG(vec2 abs_position) {
	vec2 position = ( abs_position / resolution.xy );
	vec4 color = texture2D(backbuffer, position);
	if(color.y > 0.5) {
		return 1;
	}	
	return 0;
}
void cultureG() {
	vec2 abs_position = gl_FragCoord.xy;
	
	int isAlive = cmpPixelG(abs_position);
	int numAround = 0;
	
	numAround += cmpPixelG(gl_FragCoord.xy + vec2(1.0, 0.0));
	numAround += cmpPixelG(gl_FragCoord.xy + vec2(0.0, 1.0));
	numAround += cmpPixelG(gl_FragCoord.xy + vec2(1.0, 1.0));
	numAround += cmpPixelG(gl_FragCoord.xy + vec2(-1.0, 0.0));
	numAround += cmpPixelG(gl_FragCoord.xy + vec2(0.0, -1.0));
	numAround += cmpPixelG(gl_FragCoord.xy + vec2(-1.0, -1.0));
	numAround += cmpPixelG(gl_FragCoord.xy + vec2(1.0, -1.0));
	numAround += cmpPixelG(gl_FragCoord.xy + vec2(-1.0, 1.0));
	
	
	if(numAround < 2) {
		isAlive = 0;
	} else if(numAround > 3) {
		isAlive = 0;
	} else if(numAround == 3) {
		isAlive = 1;
	}
	
	if(isAlive == 1) {
		gl_FragColor.y = 1.0;
	} else {
		gl_FragColor.y = 0.0;
	}
}

int cmpPixelB(vec2 abs_position) {
	vec2 position = ( abs_position / resolution.xy );
	vec4 color = texture2D(backbuffer, position);
	return int(color.z > 0.5);
}
void cultureB() {
	vec2 abs_position = gl_FragCoord.xy;
	
	int isAlive = cmpPixelB(abs_position);
	int numAround = 0;
	
	numAround += cmpPixelB(gl_FragCoord.xy + vec2(1.0, 0.0));
	numAround += cmpPixelB(gl_FragCoord.xy + vec2(0.0, 1.0));
	numAround += cmpPixelB(gl_FragCoord.xy + vec2(1.0, 1.0));
	numAround += cmpPixelB(gl_FragCoord.xy + vec2(-1.0, 0.0));
	numAround += cmpPixelB(gl_FragCoord.xy + vec2(0.0, -1.0));
	numAround += cmpPixelB(gl_FragCoord.xy + vec2(-1.0, -1.0));
	numAround += cmpPixelB(gl_FragCoord.xy + vec2(1.0, -1.0));
	numAround += cmpPixelB(gl_FragCoord.xy + vec2(-1.0, 1.0));
	
	
	if(numAround < 2) {
		isAlive = 0;
	} else if(numAround > 3) {
		isAlive = 0;
	} else if(numAround == 3) {
		isAlive = 1;
	}
	
	if(isAlive == 1) {
		gl_FragColor.z = 1.0;
	} else {
		gl_FragColor.z = 0.0;
	}
}

void main( void ) {
	float distance = length((mouse * resolution) - (gl_FragCoord.xy));
	if(distance > 19.0 && distance < 21.0) {
		gl_FragColor.x = 1.0;
		return;
	} else if(distance > 25.0 && distance < 27.0) {
		gl_FragColor.y = 1.0;
		return;
	} else if(distance > 30.0 && distance < 32.0) {
		gl_FragColor.z = 1.0;
		return;
	}
	
	cultureR();
	cultureG();
	cultureB();
}	