// Can somebody make a game here?

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float TILE_EXT=0.125;
const float TILE_SIZE=TILE_EXT*2.0;


void main() 
{

	vec2 p = (-resolution.xy + 2.0 * gl_FragCoord.xy) / resolution.y;
	vec2 m = (mouse * 2.0 - 1.0) * vec2(resolution.x / resolution.y, 1.0);
	
	vec2 coord = vec2(mod(p-TILE_EXT, TILE_SIZE)) * 2.0;
	float sel = 0.0;
	
	if (length(p-m) < 0.05)
	{
		sel = 1.5;
	}
	
	vec2 m_ = (m-TILE_EXT)/TILE_SIZE;
	vec2 p_ = (p-TILE_EXT)/TILE_SIZE;
	
	if (floor(m_.x) < p_.x && floor(m_.y) < p_.y && ceil(m_.x) > p_.x && ceil(m_.y) > p_.y)
	{
		coord.xy = vec2(0.0);
	}
	
	gl_FragColor = vec4( vec3(coord.xy, sel), 1.0 );

}