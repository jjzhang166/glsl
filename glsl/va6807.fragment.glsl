#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float chessboard(vec2 uv, vec2 nuv)
{
	bool pu = (mod(ceil(uv.x * nuv.x), 2.0) == 0.0);
	bool pv = (mod(ceil(uv.y * nuv.y), 2.0) == 0.0);
	
	return (pu && !pv) || (!pu && pv) ? 0.0 : 1.0;
}

vec4 texture(vec2 pos)
{
	float fval = chessboard(pos, vec2(11.0, 6.0));
	return vec4(fval, fval, fval, 1.0);
}

void main( void ) {

	vec2 mouse_pixel = mouse * resolution.xy;
	
	float res_min = min(resolution.x, resolution.y);
	
	vec2 away_from_center = (mouse_pixel - gl_FragCoord.xy) / res_min;
	
	float dist = length(away_from_center);
	
	//vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 col = vec3(dist, dist, dist);
		
	gl_FragColor = vec4(col, 1.0);
}