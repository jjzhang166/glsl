#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

vec3 lazer(vec2 pos, vec3 clr, float mult)
{
	vec3 color;
	// calc w which is the width of the lazer
	float w = fract(time*0.5);
	//w = sin(3.14156*w);
	w *= 1.5+pos.x;
	w *= 2.0;
	//w = sin(w*1.0)*1.0;
	color = clr * mult * w / abs(pos.y);
	// add a ball
	float d = distance(pos,vec2(-1.0+fract(time*0.5)*2.,0.0));
	color += (clr * 0.25*w/d);
	return color;
}

void main()
{
	vec2 pos = ( gl_FragCoord.xy / resolution.xy * 2.0 ) - 1.0;
	//pos.x *= resolution.x / resolution.y;
	vec3 color = max(vec3(0.), lazer(pos, vec3(1.75, 0.2, 3.), 0.25));
	gl_FragColor = vec4(color * 0.05, 1.0);
}
