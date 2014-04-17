#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D backbuffer;

vec2 sample(float dx, float dy) {
	vec4 c = floor(texture2D(backbuffer, (gl_FragCoord.xy+vec2(dx,dy))/resolution)*255.+.5);
	return c.gr*256.+c.ab-32768.;
}

void main( void ) {
	vec2 c1 = sample(0.,0.);
	vec2 c = c1;
	
	vec2 mp = gl_FragCoord.xy/resolution-mouse;
	
	vec2 es = sample(1.,0.)+sample(-1.,0.)+sample(0.,1.)+sample(0.,-1.);
	float a = es.y-c.y*4.+10000./(1.+dot(mp,mp)*10000.)-c.y*.1;
	c.y += c.x*.1;
	c.x = (c.x*.5+es.x*.125)+a*.1;
	if (c1.x < -32767.5) c = vec2(32767.+sin(gl_FragCoord.x*gl_FragCoord.y/resolution.x*.4)*20000.,32767.+cos(gl_FragCoord.x*.1)*20000.);
	c = max(min(floor(c+.5)+32768.,65535.),1.);
	gl_FragColor = vec4(
		floor(c.y/256.),
		floor(c.x/256.),
		mod(c.y,256.),
		mod(c.x,256.)
	)/255.;
	/*vec4 s = texture2D(backbuffer, gl_FragCoord.xy/resolution);
	gl_FragColor = vec4(gl_FragCoord.x/resolution.x);
	gl_FragColor = floor(vec4(gl_FragCoord.x/resolution.x)*255.+.5)/255.;
	gl_FragColor.g = floor(s.r*255.+.5)/255.;
	gl_FragColor.b = abs(s.r-s.g)*100.;*/
}