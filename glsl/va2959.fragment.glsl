//neat 

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

void main( void ) {
	float itt = 0.0 ;
	vec2 f = (gl_FragCoord.xy + (0.5)*vec2(sin(gl_FragCoord.x*gl_FragCoord.y),-cos(gl_FragCoord.x*gl_FragCoord.y))) / resolution.xy * 4.0 - 1.9 - surfacePosition + vec2(sin(time),-cos(time))*0.03, pos, c, z, n;
	pos = f;
	z = f;;
	c.x = 0.285 * (1.05);
	c.y = 0.01 * (sin(time)*0.5 + 2.0);
	
	float x;
	for(int i = 0 ; i < 50 ; i ++ ){
		n.x = z.x * z.x - z.y * z.y + c.x + sin(z.x*z.x)*0.01 - sin(z.y*z.y)*0.01 + sin(c.x)*0.01;
		n.y = z.y * z.x + z.x * z.y + c.y + sin(c.y)*0.01;
		
		if(length(n) > 14.0) {
			x = float(i);
			break;
		}
		z = n;
		
		itt += 1.0;
	}
	vec3 temp = normalize(vec3(z.x, z.y, itt/10.0));
	gl_FragColor = vec4(temp.zxy, 1.0);
}