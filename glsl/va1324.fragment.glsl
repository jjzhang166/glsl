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
	
	vec2 z = (mouse - 0.5) * 2.5;
	vec2 c = a-z;
	
	float r = 256.0, g = 1.0,b = 1.0, g2=1.0, b2=1.0;
	vec2 zold = vec2(0);
	
	for(float i = 0.0; i < 256.0; i++ ){
		//vec2 z0 = vec2(z.x * z.x - z.y * z.y, z.y * z.x + z.x * z.y);
		//z = vec2(z0.x * z.x - z0.y * z.y, z0.y * z.x + z0.x * z.y);
		zold = z;
		z = vec2(z.x * z.x - z.y * z.y, z.y * z.x + z.x * z.y);
		z = vec2(z.x + c.x,z.y + c.y);
		if((z.x * z.x + z.y * z.y) > 2.0*2.0){
			r = i;
			g = z.x;
			b = z.y;
			g2 = zold.x;
			b2 = zold.y;
			float q1 = log(log(g*g+b*b)/(2.0*log(2.0)))/log(2.0);
			r = (r-q1)*(1.0/256.0);
			r = min(r, 1.0);
			float d1 = abs(cos(atan(b,g)));
			float q2 = log(log(g2*g2+b2*b2)/(2.0*log(2.0)))/log(2.0);
			float d2 = abs(cos(atan(b2,g2)));
			float blend = -q2/(q1-q2);
			//blend = ((6.0*blend-15.0)*blend+10.0)*blend*blend*blend;
			d1 *= blend;
			d2 *= 1.0-blend;
			float d = abs(d1-d2);
		
			return vec3((1.0-d)*(1.0-r),(1.0-sqrt(sqrt(d)))*(1.0-r),r);

		}
	}
	
	return vec3(0.5+z.x, 0.5+z.y, 1.0);

}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xx );
	vec3 color = frctl(position);

	gl_FragColor = vec4(color, 1.0 );
}
