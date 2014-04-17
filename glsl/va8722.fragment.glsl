#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
varying vec2 surfacePosition;
uniform vec2 mouse;
uniform vec2 resolution;

//dddd
// imported helpers::
float julia(vec2 z){
	int i = 0;
	vec2 mu = vec2(
		0.40,
		0.30 //+ 0.01*sin(time*0.00001)
	);
	
	float ret = 0.0;
	
	for(int j = 0; j < 32; j++){
		if(z.x >= 5.0) break;
		//if(z.y >= 5.0 + mouse.y) break;
		//if(z.y >= 2.0) break;
		
		//z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y);
		z = vec2(z.x*z.x*z.x*1.8 - 3.3*z.x*z.y*z.y, 6.7*z.x*z.x*z.y - z.y*z.y*z.y);
		//z = vec2(z.x*z.x*z.x - 3.0*z.x*z.y*z.y, 3.0*z.x*z.x*z.y - z.y*z.y*z.y);
		
		z += mu;
		ret += 1.0;
		
		
		
	}
	//while(ret <= 128.0){
		
		
		//if(z.x >= 2.0) break;
		//if(z.y >= 2.0) break;
		
	//}

	if(ret > 2048.0){
		return -1.0;
	}

	return ret;
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
	
	//gl_FragColor = vec4(r, g, b, 1.0);
	gl_FragColor = hslToRgb(vec4(
		0.5 + 0.1*sin(time*0.5 + gl_FragCoord.x*0.007*surfacePosition.x) + 0.1*sin(time*0.35 + gl_FragCoord.y*0.027*surfacePosition.y)
		, 0.70
		, ph
		, 1.0));
}


