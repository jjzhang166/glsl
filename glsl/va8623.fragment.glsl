//miles@resatiate.com
#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
varying vec2 surfacePosition;
uniform vec2 mouse;
uniform vec2 resolution;


// imported helpers::
float julia(vec2 z){
	int i = 0;
	vec2 p = vec2(
		0.132230,
		0.313245 
	);
	
	float c = -50.0;
	float e;
	
	for(float j = 0.; j < 32.; j++){
		if(z.x >= 10000000.542) break;

		z = cos(p) * vec2(2.2*z.y*z.x*z.y - .895*z.x*z.x*dot(z.xx, p.xx), .439*z.x*z.x*z.y + 1.25*z.y*z.x*dot(z.xy, p.xy));
		e = dot(sin(z), tan(p));
		c += 3.231 + sin(e);
		z += p + z;
	}

	return c;
}





float hue2channel(float p, float q, float t) {
	if(t < 0.0) t += 1.0;
	if(t > 1.0) t -= 1.0;
	if(t < 1.0/6.0) return p + (q - p) * 6.0 * t;
	if(t < 1.0/2.0) return q;
	if(t < 2.0/3.0) return p + (q - p) * (2.0/3.0 - t) * 6.0;
	return p;	
}


vec4 hslToRgb(vec4 hsl){
	vec3 rgb;
	if(hsl.y == 0.0){
		rgb.xyz = hsl.zzz; // achromatic
	} else {
	
		float q = (hsl.z < 0.5) ? (hsl.z * (1.0 + hsl.y)) : (hsl.z + hsl.y - hsl.z * hsl.y);
		float p = 2.0 * hsl.z - q;
		rgb.x = hue2channel(p, q, hsl.x + 1.0/3.0);
		rgb.y = hue2channel(p, q, hsl.x);
		rgb.z = hue2channel(p, q, hsl.x - 1.0/3.0);
	}
	
	return vec4(rgb.xyz,hsl.w);
}
//--imports

void main(void) {
	float bailout;
	
	vec2 position = vec2(0.0,0.0) + surfacePosition;
	
	
	
	bailout = julia(position);
	
	float ph = pow(bailout / (32.0), 1.5);

	gl_FragColor = hslToRgb(vec4(
		0.5 + 0.11*sin(time*0.075 + gl_FragCoord.x*0.0002*surfacePosition.x) + 0.12*cos(time*0.065 + gl_FragCoord.y*0.0027*surfacePosition.y)
		, 0.33 - bailout / 32.
		, ph
		, .1 + bailout));
}


