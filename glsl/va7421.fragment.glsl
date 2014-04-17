precision mediump float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

bool checkConstraints(vec2 p){
	float leftX = 0.4 + sin( p.y * time ) * 0.01;
	
	return ((p.x > leftX && p.x < leftX + 0.001 && p.y > 0.4 && p.y < 0.8) ||
	       (p.x > 0.6 && p.x < 0.602 && p.y > 0.4 && p.y < 0.8) ||
	       (p.y > 0.4 && p.y < 0.402 && p.x > 0.4 && p.x < 0.601) ||
	       (p.y > 0.8 && p.y < 0.802 && p.x > 0.4 && p.x < 0.601));
}

void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution.xy);
	vec2 p1 = p + vec2( 0, 0.001 );
	vec2 p2 = p + vec2( 0.001, 0 );
	vec2 p3 = p + vec2( 0, -0.001 );
	vec2 p4 = p + vec2( -0.001, 0 );
	
	vec4 color = vec4(0, 0, 0, 1.0);
	
	bool inLine = checkConstraints(p);
	if (inLine) color.rgb += vec3(1, 1, 1);
	inLine = checkConstraints(p1);
	if (inLine) color.rgb += vec3(0.25, 0.25, 0.25);
	inLine = checkConstraints(p2);
	if (inLine) color.rgb += vec3(0.25, 0.25, 0.25);
	inLine = checkConstraints(p3);
	if (inLine) color.rgb += vec3(0.25, 0.25, 0.25);
	inLine = checkConstraints(p4);
	if (inLine) color.rgb += vec3(0.25, 0.25, 0.25);
	
	
	gl_FragColor = color;
}