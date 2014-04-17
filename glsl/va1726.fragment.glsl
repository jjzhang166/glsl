#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float round(float a){
	if(a<0.5)
		return 0.;
	return 1.;
}

vec3 frctl(vec2 a){
	a = a * 6.;
	a = vec2(a.x - 3.0, a.y - 1.5);
	
	vec2 c = vec2(sin(time * 0.5) * 1.2,cos(time * 0.5)*3.0);
	//vec2 c = a5
	vec2 z = a;
	
	float r = 1.0, g = 1.0,b = 1.0;
	
	for(float i = 0.0; i < 128.0; i++ ){
		z = vec2(z.x * z.x - z.y * z.y, z.y * z.x + z.x * z.y);
		z = vec2(z.x + c.x,z.y + c.y);
		
		z = vec2(z.x * z.x - z.y * z.y, z.y * z.x + z.x * z.y);
		z = vec2(z.x + c.x,z.y + c.y);
		
		z = vec2(z.x * z.x - z.y * z.y, z.y * z.x + z.x * z.y);
		z = vec2(z.x + c.x,z.y + c.y);
		
		z = vec2(z.x * z.x - z.y * z.y, z.y * z.x + z.x * z.y);
		z = vec2(z.x + c.x,z.y + c.y);
		if(sqrt(z.x * z.x + z.y * z.y) > 1900.0){
			r = i / 256.0;
			g = z.x;
			b = z.y;
			break;
		}
	}
	r = pow(r, 10.0);

	return vec3(r,r,b);
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xx );
	vec3 color = frctl(position);

	gl_FragColor = vec4(color, 1.0 );
}
