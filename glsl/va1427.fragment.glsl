#ifdef GL_ES
precision mediump float;
#endif
//"tree top and sky motif"coloring+tweaks_gtoledo3
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float round(float a){
	if(a<0.5)
		return 0.;
	return 1.;
}

vec3 frctl(vec2 a){
	a = a * 6.3;
	a = vec2(a.x - 3.0, a.y - 1.6);
	
	//vec2 c = (vec2(1.-mouse.x,1.-mouse.y) - 0.5) * 2.5;
	vec2 c = (vec2(mouse.x,mouse.y) - 0.5) * 2.5;
	//vec2 c = a;
	vec2 z = a;
	
	float r = 256.0, g = 1.0,b = 1.0, g2=1.0, b2=1.0;
	
	for(float i = 0.0; i < 512.0; i++ ){
		//vec2 z0 = vec2(z.x * z.x - z.y * z.y, z.y * z.x + z.x * z.y);
		//z = vec2(z0.x * z.x - z0.y * z.y, z0.y * z.x + z0.x * z.y);
		vec2 zold = z;
		z = vec2(z.x * z.x - z.y * z.y, z.y * z.x + z.x * z.y);
		z = vec2(z.x + c.x,z.y + c.y);
		if((z.x * z.x + z.y * z.y) > 2.0*2.0){
			r = i;
			g = z.x;
			b = z.y;
			g2 = zold.x;
			b2 = zold.y;
			break;
		}
	}
	float q1 = log(log(g*g+b*b)/(2.0*log(2.0)))/log(2.0);
	r = (r-q1)*(1.0/512.0);
	r = min(r, 1.0);
	float d1 = abs(cos(atan(b,g)));
	float q2 = log(log(g2*g2+b2*b2)/(2.0*log(2.0)))/log(2.0);
	float d2 = abs(cos(atan(b2,g2)));
	float blend = -q2/(q1-q2);
	//blend = ((6.0*blend-15.0)*blend+10.0)*blend*blend*blend;
	d1 *= blend;
	d2 *= 1.0-blend;
	float d = abs(d1-d2);

	return vec3((.8-d)*(.3-r),(1.-sqrt(sqrt(d-.7)))*(.5-r),r);
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xx )/1.5+vec2(.135,.05);
	vec3 color = frctl(position);
	float vignette = 1.5-length(position*2.0-1.0);

	gl_FragColor = vec4(color, 1.0 )*vignette;
	gl_FragColor *= 1.4;
}
