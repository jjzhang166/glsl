// by rotwang

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

float pattern( vec2 p )
{
	float c1 = 0.25;
    	vec2 q1 = mod(p,c1)-0.5*c1;
	
	float c2 = c1+c1*2.0;
    	vec2 q2 = mod(p,c2)-0.5*c2;

	float d = dot(q1,q2);
    return d * 25.0;
}


void main(void)
{

	vec2 unipos = (gl_FragCoord.xy / resolution);
	vec2 pos = unipos*2.0-1.0;
	pos.x *= resolution.x / resolution.y;

    float shade = pattern( pos );
    vec3 clr = vec3(shade*0.2, shade*0.6, shade*1.0);
	
	
    gl_FragColor = vec4(clr,1.0);
}