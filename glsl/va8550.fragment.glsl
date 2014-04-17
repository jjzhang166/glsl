#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
varying vec2 surfacePosition;
uniform vec2 mouse;
uniform vec2 resolution;

uniform vec2 param;
uniform int iters;
uniform vec2 viewPos;
uniform float viewZoom;
uniform float viewRatio;
uniform float anim;
uniform bool juliaMode;
uniform bool blinkMode;
//layout(location = 0) out vec4 FragmentColor;
//in vec2 pos;


float julia(vec2 z){
	int i = 0;
	vec2 mu = vec2(
		0.39*surfacePosition.x+0.1*sin(time*surfacePosition.x),
		0.29*surfacePosition.y+0.1*sin(time*surfacePosition.y)
	);
	
	float ret = 0.0;
	
	for(int j = 0; j < 128; j++){
		if(z.x >= 5.0) break;
		//if(z.y >= 5.0 + mouse.y) break;
		//if(z.y >= 2.0) break;
		
		z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y);
		//z = vec2(z.x*z.x*z.x - 3.0*z.x*z.y*z.y, 3.0*z.x*z.x*z.y - z.y*z.y*z.y);
		//z = vec2(z.x*z.x*z.x - 3.0*z.x*z.y*z.y, 3.0*z.x*z.x*z.y - z.y*z.y*z.y);
		
		z += mu;
		ret += 1.0;
		
		
		
	}
	//while(ret <= 128.0){
		
		
		//if(z.x >= 2.0) break;
		//if(z.y >= 2.0) break;
		
	//}

	if(ret > 128.0){
		return -1.0;
	}

	return ret;
}



// imported helpers::


float hue2channel(float p, float q, float t) {
	if(t < 0.0) t += 1.0;
	if(t > 1.0) t -= 1.0;
	if(t < 1.0/6.0) return p + (q - p) * 6.0 * t;
	if(t < 1.0/2.0) return q;
	if(t < 2.0/3.0) return p + (q - p) * (2.0/3.0 - t) * 6.0;
	return p;	
}


vec4 hslToRgb(vec4 hsl){

	// hue is x
	// saturation is y
	// lightness is z
	
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
	//iters = 256;
	float r, g, b;
	float bailout;
	
	vec2 position = vec2(0.0,0.0) + surfacePosition;
	
	//position.x *= 1.5;//*surfacePosition.x;
	//position.y *= 1.5;//*surfacePosition.y;
	
	
	bailout = julia(position);
	
	if(bailout == -1.0) {
		r = g = b = 1.0;
	} else {
		//int mm = bailout * 32;
		
	}
	
	float ph = pow(bailout / 128.0, 0.125);
	r = 1.0 * ph * pow(cos(time*.3333), 2.0);
	g = 1.0;
	b = 1.0 * ph * pow(sin(time*.3333), 2.0);
	
	//gl_FragColor = vec4(r, g, b, 1.0);
	gl_FragColor = hslToRgb(vec4(sin(time*.1), cos(time*.5), pow(ph, 1.9), 1.0));
}



