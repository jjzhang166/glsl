#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//love inventing new shapes :D

void main( void ) {
	vec2 p = ( gl_FragCoord.xy / resolution.xy * 2.0) - 1.0;
	p *= 2.0;
	p.x *= 1.66666;
	if(p.x < 0.0){
		p.x += 1.5;
		p *= 2.0;
		float d = 0.0;
		vec2 ap = abs(p);
		float fd = min(0.5 - ap.x, 1.05 - ap.y);
		float sd = min(1.0 - ap.x, 0.707 - ap.y);
		d = max(max(abs((fd + sd) * 0.5), fd / sd * 0.5), pow(fd, sd) * 0.2);
		gl_FragColor = vec4(smoothstep(d - 0.01, d + 0.01, 1.0 - abs(sin(time * 1.0))));
	}
	else
	{
		p.x -= 1.5;
		p *= 2.0;
		float d = 0.0;
		vec2 ap = abs(p);
		float fd = min(0.5 - ap.x, 1.05 - ap.y);
		float sd = min(1.0 - ap.x, 0.707 - ap.y);
		d = max(max(abs((fd + sd) * 0.5), fd / sd * 0.5), pow(fd, sd) * 0.2);
		gl_FragColor = vec4(d);
	}

}