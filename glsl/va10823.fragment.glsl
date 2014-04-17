#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 tex(vec2 pos)
{
	float a = sin(pos.x/10.0)/2.0+sin(pos.y/10.0)/2.0+0.5;
	float b = sin(pos.x/1.0)/2.0+sin(pos.y/7.0)/2.0+0.5;
	float c = sin(pos.x/18.0)/2.0+sin(pos.y/8.0)/2.0+0.5;
	vec4 blah = vec4(a,b,c,0.0);
	blah = floor(blah*3.0)/3.0;
	return blah;
}

void main( void ) {

	vec2 pos = gl_FragCoord.xy;
	vec4 t = tex(pos);
	float s = t.x/3.0+t.y/3.0+t.z/3.0;
	
	gl_FragColor = vec4(s,s,s,1);
}