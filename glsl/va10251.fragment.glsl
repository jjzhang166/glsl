#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 uv =2.0*(gl_FragCoord.xy/resolution.xy)-1.0;
	float col=0.0;
	float ball;
	float i=1.0;
	float time=fract(time*1.0);	

	for(float i=0.0;i<10.0;i++){
	ball += pow(i/100.0/length(uv-vec2( cos(i/10.0*2.0-1.0)-1.0 ,
		   (fract(i/10.0+time)/0.5-1.0 ))),3.0);
	}
	
	
	col =ball;
	gl_FragColor=vec4(col*0.3,col*0.4,col*0.2,1.0);
}