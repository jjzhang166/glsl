#ifdef GL_ES
precision highp float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;
const float ITERATIONS = 4096.0;

vec2 square(vec2 z) {

	return vec2 ((z.x*z.x - z.y*z.y) , (2.0*z.x*z.y));
}

float sqLength(vec2 z) {
	
	return z.x*z.x + z.y*z.y;
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

void main( void ) {
	// that's the focus coordinate
	vec2  offset = vec2(0.0,0.0);
	
	// some interesting positions:
	// uncomment to see
	//offset = vec2(0.31496,0.4285);
	//offset = vec2(-1.40165,0.0);
	offset = vec2(-0.74988,-0.01993);
	//offset = vec2(0.05998,-0.61999);
	
	//vec2  offset = mouse-vec2(0.5,0.5);
	// start getting ugly near 10^5
	// float scale = 10000.0;
	
	float scale = mix(0.5,5000.0,pow((1.0-mouse.y),5.0));	
		
	float scaleCoord = min(resolution.x,resolution.y);
	vec2  middle = resolution / (2.0 * scaleCoord);
	
	vec2 c = (((gl_FragCoord.xy/scaleCoord) - middle)) / scale + offset;
	vec2 z = vec2(0.0,0.0);
	
	vec4 color = vec4(0.0,0.0,0.0,1.0);
	for (float i = 0.0; i < ITERATIONS; i ++) {
		z = square(z) + c;
		if(sqLength(z) >= 4.0){
			color = hslToRgb(vec4(pow(i/ITERATIONS,0.25),0.5,0.5,1.0));
			break;
		}
	}
	
	gl_FragColor = color;
	
	//gl_FragColor = vec4(0,0,0,0);
}