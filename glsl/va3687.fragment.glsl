// by rotwang, some background shades for Krysler(2012)
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;


float Krysler_055( vec2 p, float g )
{
	
	float dx = max( abs(p.x), 0.0);
	float dy = max( p.y*g, 0.0);
	//float d = pow( max(-dx,dy), length(sqrt(p)));
	float d = pow( max(-dx,dy), length(p))*2.0;
	d+= 0.75-length(p);
	return d;
}

vec3 Krysler_055_clr( vec2 p )
{
	
	float a = Krysler_055(p, 1.0);
	float b = Krysler_055(p, -1.0);
	vec3 clr_a = vec3(a*0.2, a*0.6, a*1.0);
	vec3 clr_b = vec3(b*1.0, b*0.6, b*0.2);
	vec3 clr = mix(clr_a,clr_b, 0.5);
	return clr;
}


void main(void)
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    p.x *= resolution.x / resolution.y;
	

	vec3 clr = Krysler_055_clr(p);

    gl_FragColor = vec4(clr, 1.0);
}