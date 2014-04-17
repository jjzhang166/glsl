#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 uv = ( gl_FragCoord.xy / resolution.xy );

	vec3 c = vec3(0.0);
	
	const int maxStep = 50;
	
	for(int i = 0; i  < maxStep; i++)
	{
		float a = smoothstep(uv.x,float(i),0.5 + sin(time*3.0)*0.2);
		float b = smoothstep(uv.y,float(i),0.25 - sin(time*3.0)*0.2);
		
		c += a + b;
		
		if(a>b) {
			c.r = 1.0;	
		}
		else {
			c.b = 1.0;	
		}
	}
	
	float r = 0.5 + uv.x*0.1;
	
	c.g -= r;
	
	gl_FragColor = vec4(c,1.0);

}