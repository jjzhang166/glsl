#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float ang = mouse.x*7.0;
	vec2 pos =  vec2(gl_FragCoord.x*cos(ang)-gl_FragCoord.y*sin(ang), gl_FragCoord.x*sin(ang)+gl_FragCoord.y*cos(ang));
	float t = time+mouse.y*100.0;
	float blah = sin(pos.x/(sin(t*0.12)*50.0))+1.5;
	
	float segs = floor((sin(pos.y/(sin(t*0.13)*50.0))+1.0)*sin(t*2.41)*5.0)+1.0;
	blah = floor(blah*segs)/segs;
	segs = floor((sin(pos.y/(sin(t*0.24)*50.0))+1.0)*sin(t*3.24)*5.0)+1.0;
	float blah2 = floor(blah*segs)/segs;
	segs = floor((sin(pos.y/(sin(t*0.167)*50.0))+1.0)*sin(t*1.24)*5.0)+1.0;
	float blah3 = floor(blah*segs)/segs;
	vec3 bias = vec3(sin(t*0.014)*0.5+0.5, sin(time*0.021)*0.5+0.5, sin(t*0.038)*0.5+0.5);
	vec4 combined = vec4(blah*bias.x,blah2*bias.y,blah3*bias.z,1);
	float grey = (combined.x+combined.y+combined.z)/3.0;
	float frac = sin(t*0.1);
	gl_FragColor = frac*combined+(1.0-frac)*grey;
}