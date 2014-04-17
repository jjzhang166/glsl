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
	a = vec2(a.x - 3.0, a.y - 1.6);
	
	vec2 c = vec2(sin(time),cos(time));
	//vec2 c = a;
	vec2 z = a;
	
	float r = 1.0, g = 1.0,b = 1.0;
	
	for(float i = 0.0; i < 512.0; i++ ){
		//vec2 z0 = vec2(z.x * z.x - z.y * z.y, z.y * z.x + z.x * z.y);
		//z = vec2(z0.x * z.x - z0.y * z.y, z0.y * z.x + z0.x * z.y);
		z = vec2(z.x * z.x - z.y * z.y, z.y * z.x + z.x * z.y);
		z = vec2(z.x + c.x,z.y + c.y);
		float st = pow(sin(time * 1.7294) + 2.,2.);
		if(sqrt(z.x * z.x + z.y * z.y) > st){
			r = i / 256.0;
			g = z.x;
			b = z.y;
			break;
		}
	}
	r = log(r);
	
	return vec3(round(r),round(g)-0.4,round(b)-0.4).rrb;
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xx );
	vec3 color = frctl(position);

	gl_FragColor = vec4(color, 1.0 );
}
