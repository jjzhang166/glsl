// rotwang mod*, playing with the 'thing'

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 reyboard;


float thing(vec2 pos) 
{
	pos.x=fract(pos.x+.5)-.5;
	pos.y=fract(pos.y+.5)-0.5;
	//pos = max(abs(pos) - 0.7, 0.0);
	pos = abs(pos);

	return (max(pos.x+pos.y*0.57735,pos.y)-.5);
	//return length(pos) - 1.0;
}

void main(void) 
{
	float aspect = resolution.x / resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
	vec2 pos = unipos*2.0-1.0;
	pos.x *= aspect;
	float dist = thing(pos);
	float d = smoothstep( 0.03, 0.06, abs(dist));
	
	
	vec3 clr_a = vec3(0.2, 0.9, 0.4) * vec3(1.0 - abs(dist * 15.0));
	vec3 clr_b = vec3(0.0);
	vec3 clr_c = vec3( 0.3, dist*(sin(time*5.0)-6.0)-0.2, dist*(cos(time*0.5)) + 0.35 );
	
	vec3 clr = mix(clr_a, clr_b, d);
	clr = mix(clr, clr_c, dist*-sin(d));
	gl_FragColor.rgb = clr;
}