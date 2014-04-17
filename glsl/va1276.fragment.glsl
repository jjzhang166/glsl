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
	a = vec2(a.x - 3.0, a.y - 2.2);
	
	vec2 c = vec2(sin(time/5.0),cos(time/1.0));
	//vec2 c = a;
	vec2 z = a;
	
	float r = 1.0, g = 1.0,b = 1.0;
	
	for(float i = 0.0; i < 512.0; i++ ){
		//vec2 z0 = vec2(z.x * z.x - z.y * z.y, z.y * z.x + z.x * z.y);
		//z = vec2(z0.x * z.x - z0.y * z.y, z0.y * z.x + z0.x * z.y);
		z = vec2(z.x * z.x - z.y * z.y, z.y * z.x + z.x * z.y);
		z = vec2(z.x + c.x,z.y + c.y);
		if(sqrt(z.x * z.x + z.y * z.y) > 19001.0){
			r = i / 256.0;
			g = z.x;
			b = z.y;
			break;
		}
	}
	r = pow(r, 0.5);

	return vec3(round(r),round(g)-0.4,round(b)-0.4).brr;
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xx );
	vec3 color = frctl(position);

	gl_FragColor = vec4(color, 1.0 );
}
