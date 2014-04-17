#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 resolution;



void main( void ) {
		
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec3 color = vec3(0.0);
	float zoom=0.5;
	
	
	float r=cos(sin((time*position.y/128.0/zoom+sin(time)))*(sin(time*position.x/32.0/zoom+time))+time)*0.4+0.4;
	float g=sin(cos((time*position.y/64.0/zoom+sin(time)))*(cos(time*position.x/64.0/zoom+time))+time)*0.4+0.4;
	float b=cos(sin((time*position.y/256.0/zoom+sin(time/8.0)))*(sin(time*position.x/128.0/zoom+time))+time)*0.4+0.4;
	
	color=vec3(r,g,b);
	if(position.y*2.1>=1.0+sin(time) && position.y*2.1<=1.1+sin(time)){
		color=vec3((sin((position.x*8.0+time*2.0))*0.3+0.7),(sin((position.x*8.0+(time+8.0)*4.0))*0.3+0.7),(sin((position.x*8.0+(time+8.0)*2.0))*0.3+0.7));
	}

	vec4 final = vec4(color, 1.0);
	gl_FragColor = final;

}