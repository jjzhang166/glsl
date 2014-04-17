// by rotwang

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;

const float PI = 3.1415926535;


float uosc = sin(time)*0.5+0.5;


float Organ_115(vec2 p, float rota)
{
	float a = atan(p.x,p.y);
    	float r = length(p);
	float invr = 1.0-r;
	float sides = 3.0;
	
	float caw = cos(sides*a+rota);
    	float h = 0.5+0.5*caw;

	float d = h-r;
	float e = r/h;
	float inve = 1.0-e;
	d = abs(d)/d;
	d *= sqrt(inve);

	return d;
}

vec3 Organ_115_clr(vec2 p, vec3 clra, vec3 clrb)
{
	float a = Organ_115(p, PI);
	float b = Organ_115(p, 0.0);
	vec3 clrm = mix(a * clra , b *clrb, 0.5);
	vec3 clr = max(a * clra , b *clrb);
	float sm = sin(time)*0.5+0.5;
	clr = smoothstep( vec3(sm), clrm+sm, clr);
	clr *= sqrt(a*b);
	return clr;
}


void main(void)
{
float aspect = resolution.x / resolution.y;
vec2 unipos = gl_FragCoord.xy / resolution;
vec2 pos = vec2(  unipos.x , unipos.y)*2.0-1.0;
pos.x *=aspect;
float a = atan(pos.x,pos.y);
float r = length(pos);
	
	vec3 clra = vec3(0.2, 0.6, 1.0);
	vec3 clrb = vec3(1.0, 0.6, 0.2);
	
	vec3 clr = Organ_115_clr(pos, clra, clrb);
	
	gl_FragColor = vec4(clr, 1.0);
}