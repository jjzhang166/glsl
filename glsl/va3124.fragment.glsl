// by rotwang (2012)
// @mod* faster animation tempo
#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}


void main()
{
	float aspect = resolution.x /resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
	vec2 pos = unipos*2.0-1.0;
	pos.x *=aspect;
	
	float scale = 0.66;
	float len = length(pos) * 1.0/scale;
	float invlen = 1.0- len;

	float sint = sin(time*0.5);
	float usint = sint*0.5+0.5;
	

	float hue = 0.6 + 0.5 *usint* unipos.y;
	float sat = 0.5 * unipos.y;
	float lum = pow(invlen,0.5)*unipos.y;
	
	vec3 clr = hsv2rgb(hue, sat, lum);

	gl_FragColor = vec4(clr, 1.0);
}