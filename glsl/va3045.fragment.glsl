#ifdef GL_ES
precision mediump float;
#endif

// Saved again for better screenshot

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution.xy;
	p.x *= resolution.x/resolution.y;
	
	vec2 mp = mouse;
	mp.x *= resolution.x/resolution.y;
	
	p.xy += vec2(sin(time*2.0), cos(time*2.0))/6.0;
	
	vec3 color = vec3(0.0,0.0,0.2);
	
	if(distance(mp.xy,p.xy)<=0.05*(sin(time*2.0)+1.5))
		color += vec3(0.0,1.0,0.0);

	if(distance(mp.xy,p.xy+vec2(0.1,0.1))<=0.05*(sin(time*2.0)+1.5))
		color += vec3(0.0,0.5,1.0);

	if(distance(mp.xy,p.xy+vec2(-0.1,0.1))<=0.05*(sin(time*2.0)+1.5))
		color += vec3(1.0,0.0,0.0);

	if(distance(mp.xy,p.xy+vec2(0.0,0.2))<=0.05*(sin(time*2.0)+1.5))
		color += vec3(3.0*distance(mp.xy,p.xy+vec2(-0.1,0.1)),0.0,0.0);
	
	gl_FragColor = vec4(color,0.0);

}