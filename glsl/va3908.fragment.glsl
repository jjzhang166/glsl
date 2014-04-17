// by rotwang, some patterns from Krysler(2012)

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

float Krysler_188( vec2 p )
{
	float c1 = 0.25;
    	vec2 q1 = mod(p,c1)-0.5*c1;
	q1 += pow(q1,vec2(1.0/2.0));
	
	float c2 = c1+c1*2.0;
    	vec2 q2 = mod(p,c2)-0.5*c2;
	q2 += pow(q2,vec2(1.0/8.0, 1.0/16.0));
	
	float c3 = c1+c1*3.0;
    	vec2 q3 = mod(abs(p),c3)-0.5*c3;
	q3 += pow(q3,vec2(1.0/16.0, 1.0/8.0));
	
	//float d1 = max(q1.y * q2.x - q3.x, q1.x * q2.y * q3.y);
	float d2 = max(q1.x * q2.x * q3.x, q1.y * q2.y - q3.y*0.5);
    return d2 * 2.0;
}


void main(void)
{

	vec2 unipos = (gl_FragCoord.xy / resolution);
	vec2 pos = unipos*2.0-1.0;
	pos.x *= resolution.x / resolution.y;

    float shade = Krysler_188( pos );
    vec3 clr = vec3(shade*0.2, shade*0.6, shade*1.0);
	
	
    gl_FragColor = vec4(clr,1.0);
}