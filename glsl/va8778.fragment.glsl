#ifdef GL_ES
precision mediump float;
#endif

const float DELTA = 0.0075;
const float F = 3.1415926535 * 2.0 / 3.0;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec2 point(float seed)
{
	vec2 point = vec2(0.0);
	point.x = cos(time+sin(time + seed));
	point.y = sin(time+cos(time * seed));
	point *= 0.75 + sin(time * 10.0) * 0.1;
	point += vec2(1.0);
	point /= 2.0;
	return point;
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 f = texture2D(backbuffer, pos).rgb;
	vec3 f2 = texture2D(backbuffer, pos + vec2(DELTA, 0)).rgb + 
		texture2D(backbuffer, pos + vec2(-DELTA, 0)).rgb + 
		texture2D(backbuffer, pos + vec2(0, DELTA)).rgb + 
		texture2D(backbuffer, pos + vec2(0, -DELTA)).rgb;
	f2 /= 4.0 + (sin(time*10.0) * 0.1);
	//if(f < 0.2)
	f = f2;
	
	for(float s = 0.0; s < 10.0; s += 1.0)
		if(length(pos - point(s)) < 0.01  + sin((time+s)*10.0) * 0.005)
			f += vec3(sin(time+s) / 2.0 + 0.5, sin(time+s + F) / 2.0 + 0.5, sin(time+s + F * 2.0) / 2.0 + 0.5);
	if(mod(time, 10.0) < 1.0)
		f -= vec3(0.01);
	gl_FragColor = vec4(f, 1.0);

}