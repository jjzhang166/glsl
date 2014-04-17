// by rotwang

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
	

vec2 Krysler_195(vec2 p)
{
	float sz = 1.0/16.0;
	float na = pow(abs(p.x*2.0),4.0);
	float a = 1.0-max(na, sz);
	
	float nb = pow(abs(p.y*2.0),12.0);
	float b = 1.0-max(nb, sz*0.5);

	return vec2(a,b);
}

vec3 Krysler_195_clr(vec2 p)
{
	vec2 shade = Krysler_195(p);

	float f = (shade.x+shade.y);
	float g = min(shade.x,shade.y);
	float h = max(shade.x,shade.y);
	
	vec3 clr_a = vec3(f*f-g*0.5);
	vec3 clr_b = vec3(1.05-h);
	
	vec3 clr = vec3(0.2,0.7,1.0) - clr_b*clr_a*2.0;
	return clr;
}


void main(void)
{
    vec2 pos = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    pos.x *= resolution.x / resolution.y;
	
	vec3 clr = Krysler_195_clr(pos);
    gl_FragColor = vec4(clr,1.0); 
}