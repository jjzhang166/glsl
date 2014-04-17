#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//round-edged rotated clipping for GLES20 by Matt DesLauriers
//http://devmatt.wordpress.com
//best viewed at 1x resolution

const vec2 clip_pos = vec2(400.0, 250.0);
const vec2 clip_size = vec2(250.0, 100.);
const float BLUR = 0.1; //1.0 leads to a smooth edge
const float ROUND_EDGE = 10.0;

float clip(vec2 p, float rotation) {
	float c = cos(-rotation);
	float s = sin(-rotation);
	
	//adjust for round edge.. can be removed
	//if no round edges are needed
	p -= ROUND_EDGE;
	vec2 ps = clip_pos;
	vec2 sz = clip_size - ROUND_EDGE*2.0;
	
	//unrotate rectangle
	float rx = ps.x + c * (p.x - ps.x) - s * (p.y - ps.y);
	float ry = ps.y + s * (p.x - ps.x) + c * (p.y - ps.y);
	
	//determine rectangle
	vec2 v = abs(vec2(rx, ry) - ps - sz/2.) - sz/2. + 0.5; 
	float d = length(max(v, 0.0));
	return smoothstep(BLUR + ROUND_EDGE, ROUND_EDGE, d);
}

void main( void ) {
	vec2 position = gl_FragCoord.xy;
	
  	float c = clip(position, time*0.25);
	
	gl_FragColor = vec4( vec3(c), 1.0 );
}