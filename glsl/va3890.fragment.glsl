#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / min(resolution.x,resolution.y) );
	vec3 color = vec3(0.0);
	
	//Hills
	
	float h = sin(p.x*1.1-0.85)*0.25,
	      h2 = sin(p.x*2.0+1.5)*0.20,
	      h3 = sin(p.x*1.75+0.75)*0.20;
	
	float d = distance(p,vec2(p.x,h));
	
	color = vec3(0.0,1.0,0.5)* vec3(1.0-pow(d,0.25));
	
	d = distance(p,vec2(p.x,h2));
	
	if(p.y < h2 && p.y > h)
		color = vec3(0.0,1.0,0.0)* vec3(1.0-pow(d,0.25));
	
	d = distance(p,vec2(p.x,h3));
	
	if(p.y < h3 && p.y > h && p.y > h2)
		color = vec3(0.0,1.0,0.0)* vec3(1.0-pow(d,0.25));
	
	if(p.y > h && p.y > h2 && p.y > h3)
	{
	 color = mix(vec3(0.75,0.75,1.0),vec3(0.6,0.8352,1.0),p.y);//Sky	
	}
	
	vec2 sun = vec2(1.5,0.75);
	
	d = distance(p,sun);
	
	if(sin(atan((p.y-sun.y)/(p.x-sun.x))*16.0+time*2.0) > 0.0)
		color = mix(color, vec3(1.0,1.0,0.0),clamp((1.0-d*5.0),0.0,1.0));//Sunbeams
	
	if(d < 0.125)
		color = vec3(1.0,1.0,0.0);
	
		
	
	gl_FragColor = vec4( color , 1.0 );

}