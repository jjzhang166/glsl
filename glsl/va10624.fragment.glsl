#ifdef GL_ES
precision mediump float;
#endif


vec2 mouse;
uniform vec2 resolution;
uniform float time;

void main(){
	vec4 col;
	float alpha;
	col = vec4(0.0,0.25,0.75,1.0);
	float left = resolution.x/2.0-20.0;
	float right = resolution.x/2.0+20.0;
	
	
	if(gl_FragCoord.x < right && gl_FragCoord.x > left){
		alpha = 1.0;
	}
	else{
		alpha = 0.25/pow((distance(vec2(resolution.x/2.0,gl_FragCoord.y),gl_FragCoord.xy)*0.01),2.0);
	}
	
	gl_FragColor = col*vec4(alpha,alpha,alpha,1.0);
}