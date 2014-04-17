// by rotwang, Facade Animation from Krysler(2012)
// @mod+  color function
// @mod+  vignette
// @mod+ camera animation over facade, needs sampling=0.5

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
float aspect = resolution.x / resolution.y;


float Krysler_188( vec2 p )
{
	float c1 = 0.25;
    	vec2 q1 = mod(p,c1)-0.5*c1;
	q1 += pow(q1,vec2(1.0/2.0));
	
	float c2 = c1+c1*2.0;
    	vec2 q2 = mod(p,c2)-0.5*c2;
	q2 += pow(q2,vec2(1.0/8.0, 1.0/16.0));
	
	float c3 = c1+c1*3.0;
    	vec2 q3 = mod(abs(p),c3)-0.75*c3;
	q3 += pow(q3,vec2(1.0/16.0, 1.0/8.0));
	
	//float d1 = max(q1.y * q2.x - q3.x, q1.x * q2.y * q3.y);
	float d2 = max(q1.x * q2.x * q3.x, q1.y * q2.y - q3.y*0.5);
    return d2 * 2.0;
}

vec3 Krysler_188_clr( vec2 p , vec2 q )
{
	float shade = Krysler_188( q );
	float d = smoothstep(0.1,1.3,shade);
	vec3 clra = vec3(shade*0.2, shade*0.6, shade*1.0);
	vec3 clrb = vec3(1.0, 0.6, 0.2);
	
	vec3 clr = mix(clra,clrb, d);
	clr += clrb*(0.25+p.y);
	clr += clra*0.5-p.y;
    return clr;
}

vec3 vignette(vec2 p, vec3 clr)
{
	vec2 vig = p*0.43;
	vig.y *= aspect;
	float amount = 1.0- length(vig);
	clr *= amount;
	return clr;
}

void main(void)
{
	
	vec2 unipos = (gl_FragCoord.xy / resolution);
	vec2 pos = unipos*2.0-1.0;
	pos.x *= aspect;

	vec2 q = pos;
	q.x += sin(time*0.1)*3.0;
	q.y += time*0.1;
	
    	vec3 clr = Krysler_188_clr( pos, q );

	clr = vignette(pos, clr);
	
	
    gl_FragColor = vec4(clr,1.0);
}