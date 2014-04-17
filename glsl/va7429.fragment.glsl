precision mediump float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

bool checkConstraints(vec2 p){
	float leftX = cos(sin(p.y * time));
	
	return ((p.x > leftX && p.x < leftX + 0.01 && p.y > 0.4 && p.y < 0.8) ||
	       //(p.x > 0.6 && p.x < 0.601 && p.y > 0.4 && p.y < 0.8) ||
	       //(p.y > 0.4 && p.y < 0.402 && p.x > 0.4 && p.x < 0.601) ||
	       (p.y > 0.8 && p.y < 0.802 && p.x > 0.4 && p.x < 0.601));
}

void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution.xy);
	
	bool inLine = checkConstraints(p);
	
	vec4 color = vec4(0, 0, 0, 1.0);
	if (inLine)
		color.rgb = vec3(1, 1, 1);
	
	gl_FragColor = color;

}