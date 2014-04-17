// by G
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(54.8464,876.573))) * 5474.446);
}
void main( void ) {
	
	float thickness = 0.20;
	vec3 bg_color = vec3(1,1,1);
	vec3 line_color = vec3(0,0.5,1);
	float tile_size = min(resolution.x,resolution.y)/10.0;
	
	vec2 position = gl_FragCoord.xy+ mouse*200.0;
	
	vec2 tile = mod(position, tile_size)/tile_size;
	
	int d = int(rand(floor(position/tile_size))<0.5);
	float l1 = length(tile-vec2(0,1-d));
	float l2 = length(tile-vec2(1,  d));
	vec3 color = mix(bg_color, line_color, float((l1 < 0.5+thickness && l1 > 0.5-thickness) || (l2 < 0.5+thickness && l2 > 0.5-thickness)));
	
	gl_FragColor = vec4( color, 1.0 );
}