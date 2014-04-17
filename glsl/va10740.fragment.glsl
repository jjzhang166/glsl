#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat2 rot90 = mat2( vec2(0, -1), vec2(1, 0));

float generateHeight(vec2 pos){
	//return sin(length(pos-vec2(0.5,0.5))*100.0+time*4.0)*sin(length(pos-vec2(0.0,0.5))*100.0+time*4.0);
	//return sin(pos.x*100.0)+sin(pos.y*100.0);
	//return 1.0;
	float r = sin(pos.x*pos.y*100.*cos(pos.x*77.77)*time)*cos(tan(log(pos.x)+pos.y/time))/fract(tan(pos.x*pos.x*pos.y)*(time)*100.);
	return sin(r+time);
}

vec3 generateNormal(vec2 pos){
	float x = pos.x;
	float y = pos.y;
	
	vec3 lH = vec3( 1.0, 0.0, generateHeight(pos + vec2(1.0/resolution.x,0.0) ) );
	vec3 uH = vec3( 0.0, 1.0, generateHeight(pos + vec2(0.0,1.0/resolution.y) ) );
	//vec3 rH = vec3( -1.0, 0.0, generateHeight(pos + vec2(-1.0,0.0) ) );
	//vec3 dH = vec3( 0.0, -1.0, generateHeight(pos + vec2(0.0,-1.0) ) );
	vec3 H = vec3( 0.0, 0.0, generateHeight(pos));
	
	vec3 normal = cross( lH - H, uH - H);
	
	//vec3 normal = uH-H;
	return normalize(normal);
}

void main( void ) {
	
	vec2 coords = vec2( gl_FragCoord.xy / resolution.xy );
	
	vec3 position = vec3(coords, 0.0);

	float color = 0.0;
	
	vec3 mouse = vec3(mouse, 0.1);
	
	//color = (0.1/length(mouse-position));
	
	color = dot(normalize(mouse-position),generateNormal(coords))*(0.1/length(mouse-position));
	
	color = generateHeight(coords);
	
	gl_FragColor = vec4( vec3( color, color, color), 1.0 );
	
	//gl_FragColor = vec4( generateNormal(coords), 1.0 );
	
}