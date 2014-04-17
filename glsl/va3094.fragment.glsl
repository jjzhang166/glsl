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
	vec4 p = gl_FragCoord;
	vec4 pos = vec4(300.0, 300.0, 0, 0);
	
	color.x = (50.0/distance(pos, gl_FragCoord));	
	//color.x = time * (1.0/gl_FragCoord.x * 1.0/gl_FragCoord.y);
        	
	//color.x = (time * (1.0/gl_FragCoord.x)) * ((1.0/gl_FragCoord.y))*time*.01;
	color.y = sin(tan(color.x)*time*2.0);//tan((1.0/gl_FragCoord.x) * ((1.0/gl_FragCoord.y))*time*.01);
	//sin(gl_FragCoord.x * time*.001) * sin(gl_FragCoord.y * gl_FragCoord.x * time*0.001) * position.x;
	//color.y = tan(gl_FragCoord.y*.0001*time * gl_FragCoord.x) * position.x;
	//color.z = log(color.y);
	
	
	
	
	gl_FragColor=color;
}