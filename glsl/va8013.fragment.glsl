#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//rotated lines
//http://devmatt.wordpress.com
//best viewed at 1x resolution

//see here for round rect: http://glsl.heroku.com/e#8013.4

const float BLUR = 1.0; //1.0 leads to a smooth edge

float rect(vec2 p, vec2 pos, vec2 size, float rotation) {
	float c = cos(rotation);
	float s = sin(rotation);	
	size -= BLUR;
	pos += BLUR/2.;
	float rx = pos.x + c * (p.x - pos.x) - s * (p.y - pos.y);
	float ry = pos.y + s * (p.x - pos.x) + c * (p.y - pos.y);	
	//determine rectangle
	vec2 v = abs(vec2(rx, ry) - pos - size/2.) - size/2. ;
	float d = length(max(v, 0.0));
	return smoothstep(BLUR, 0.0, d);
}

float line(vec2 p, vec2 a, vec2 b, float thickness) {
	float d = distance(a, b);
	float r = atan(b.y-a.y, b.x-a.x);
	return rect(p, a, vec2(d, thickness), -r);
}

void main( void ) {
	vec2 position = gl_FragCoord.xy;
	
  	//float c = rect(position, clip_pos, clip_size, .5);
	
	float c = line(position, vec2(20.0, 400.), vec2(150.0, 50.0), 5.0);
	c += line(position, vec2(30.0, 200.), vec2(50.0, 50.0), 2.5);
	gl_FragColor = vec4( vec3(c), 1.0 );
}