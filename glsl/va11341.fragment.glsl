#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float random( vec2 coord ) {
	return fract(cos(tan(fract(time*coord.x+coord.y)+0.12345)));
}

void main( void ) {
	vec3 col = vec3(0.2,0.1,0.2);
	float left = resolution.x/3.0;
	float right = left*2.0;
	
	
	
	if(gl_FragCoord.x < left || gl_FragCoord.x > right)
	{
		col += vec3((sin(time*10.0)-sin(time*10.0)*2.0)*0.50);
		col += vec3(random(gl_FragCoord.xy/1000.12345678),0.0,0.0);
	}
	else
	{
		col = vec3(random(gl_FragCoord.xy/sin(time*100.0)),0.0,0.0);
	}
	gl_FragColor = vec4(col,1.0);

}