// by rotwang

#ifdef GL_ES
precision highp float;

#endif

uniform vec2 resolution;
uniform float time;

float Krysler_117( vec2 p,  float smooth )
{
	float da = length(p)-abs(p.x)*0.75;
	float db = length(p)-abs(p.y)*0.75;
	float dab = max(da,db)*1.95;
	vec2 pa = p*p  +dab+p.x*2.0;
	
	vec2 pb = p*p - p.x;
	float tb = dot(pb, pa)+dab;
	
	
	float shade = tb-1.0;
	shade = smoothstep(0.0+smooth, 0.0-smooth, shade);
	shade += 1.0 - length(p);
    return shade;
}

vec3 Krysler_117_color( vec2 p, vec3 c, float shade)
{
 	vec3 clr = shade * c;
	clr = mix(clr , clr* max(p.y,0.125),0.25);
	return clr;
}


void main(void)
{
	vec2 p = -2.0 + 4.0 * gl_FragCoord.xy / resolution.xy;
	p.x /= resolution.y/resolution.x;
	
	float sa = Krysler_117( p, 0.05 );
	vec3 clra = Krysler_117_color(p, vec3(0.2, 0.6, 1.0), sa);
	float sb = Krysler_117( -p, 0.05 );
	vec3 clrb = Krysler_117_color(p, vec3(1.0, 0.6, 0.2), sb);
 	//vec3 clr = mix(clra, clrb, 0.5);
	vec3 clr = max(clra ,clrb);
    gl_FragColor = vec4(clr,1.0);
}