#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D sampler;

void main( void ) {
	vec4 color = vec4(0,0,0,1);
	vec2 position = (gl_FragCoord.xy / resolution.xy);
	
        	
	
	//color.x = sin(gl_FragCoord.x * time*.001) * sin(gl_FragCoord.y * gl_FragCoord.x * time*0.001) * position.x;
	//color.y = tan(gl_FragCoord.y*.0001*time * gl_FragCoord.x) * position.x;
	//color.z = log(color.y);
	
	
	//begin RH2 hack.
	color.x=-.55*log(gl_FragCoord.x*sin(gl_FragCoord.x*.3*time)+mod(time,gl_FragCoord.y));
	color.y=-.72*log(gl_FragCoord.x*sin(gl_FragCoord.x*.2*time)+mod(time,gl_FragCoord.y));
	color.z=-.98*log(gl_FragCoord.x*sin(gl_FragCoord.x*.1*time)+mod(time,gl_FragCoord.y));
	
	
	
	
	gl_FragColor=color;
}