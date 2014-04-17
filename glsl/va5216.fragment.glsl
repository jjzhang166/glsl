#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//Polygons : by CuriousChettai@gmail.com

void main( void ) {
	vec2 uPos = gl_FragCoord.xy/resolution.y;
	uPos += vec2(-0.5*resolution.x/resolution.y, -0.5);

	float radius = 0.3 + (sin(time*2.0)+1.0)/150.0;
	float faceCount = 3.0 + floor(mod(time*2.0, 20.0));
	float dist = length(uPos);
	
	float angle = atan(uPos.y, uPos.x) + sin(time)/10.0;
	angle = mod(angle, 2.0*3.14/faceCount);
	angle -= 3.14/faceCount;
	

	float edgeLength = radius / cos(angle);
	
	float color = 1.0 - smoothstep(edgeLength-0.002, edgeLength, dist);
	gl_FragColor = vec4(color);
}