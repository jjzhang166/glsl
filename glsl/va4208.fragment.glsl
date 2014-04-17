// by G
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(54.8464, 876.573))) * 5474.446);
}
void main( void ) {
	
	float thickness = 0.15;
	vec3 bg_color = vec3(1,1,1);
	vec3 line_color = vec3(0,0.5,1);
	float tile_size = min(resolution.x, resolution.y)/10.0;
	
	vec2 position = gl_FragCoord.xy+ mouse*200.0;
	
	vec2 tile = mod(position, tile_size)/tile_size;
	
	float t = floor(time/4.0);
	
	int d1 = int(rand(floor(position/tile_size)+t)<0.5);
	float l11 = length(tile-vec2(0,1-d1));
	float l21 = length(tile-vec2(1,  d1));
	vec3 color1 = mix(bg_color, line_color, float((l11 < 0.5+thickness && l11 > 0.5-thickness) || (l21 < 0.5+thickness && l21 > 0.5-thickness)));
	
	int d2 = int(rand(floor(position/tile_size)+t+1.0)<0.5);
	float l12 = length(tile-vec2(0,1-d2));
	float l22 = length(tile-vec2(1,  d2));
	vec3 color2 = mix(bg_color, line_color, float((l12 < 0.5+thickness && l12 > 0.5-thickness) || (l22 < 0.5+thickness && l22 > 0.5-thickness)));
	
	gl_FragColor = vec4( mix(color1,color2, min(1.0, mod(time, 4.0))), 1.0 );
}