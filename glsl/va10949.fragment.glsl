#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;


vec3 lazer(vec2 pos, vec3 clr, float mult)
{
	
	float x = time/5.5 * 16.0;
	float w = fract(x*0.1);
	w = sin(3.14156*w);
	w *= 2.5+pos.x;
	w *= 4.0;
        vec3 color = clr * mult  / abs(pos.y);

	float d = distance(pos,vec2(-1.0+fract(x*0.5)*2.,0.0));
	color += (clr * 0.14*w/d);
	return color;
}

void main()
{
	vec2 pos = ( gl_FragCoord.xy / resolution.xy * 2.0 ) - 1.0;
	vec3 color = max(vec3(0.), lazer(pos, vec3(0.1, 0.2, 0.), 0.215));
	gl_FragColor = vec4(color * 0.1, 1.0);
}
