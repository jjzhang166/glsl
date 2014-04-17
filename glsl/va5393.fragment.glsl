#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

vec2 ratio=vec2(1.0,resolution.y/resolution.x);



// vertical Shader

vec3 HSVtoRGB(vec3 hsv)
{
	vec3 col;
	float hue = mod(hsv.r, 360.0);
	float s = max(0., min(1., hsv.g));
	float v = max(0., min(1., hsv.b));
	if(s > 0.0) {
		int h = int(floor(hue / 60.0));
		float f = hue / 60.0 - float(h);
		float p = v * (1.0 - s);
		float q = v * (1.0 - f * s);
		float r = v * (1.0 - (1.0 - f) * s);

		if(h == 0) col = vec3(v, r, p);
		else if(h == 1) col = vec3(q, v, p);
		else if(h == 2) col = vec3(p, v, r);
		else if(h == 3) col = vec3(p, q, v);
		else if(h == 4) col = vec3(r, p, v);
		else col = vec3(v, p, q);
	}else{
		col = vec3(v);
	}
	return col;
}

void main( void ) {

	vec2 position = (( gl_FragCoord.xy / resolution.xy )  * vec2(2, 2) - vec2(1, 1)) * ratio;
	
	float len = length(position);
	if(len < 0.4) {
		float h = (atan(position.y, position.x) + time) * 180.0 / 3.141592;
		vec3 rgb = HSVtoRGB(vec3(h, len / 0.4, 1.));
		gl_FragColor = vec4(rgb,1);
	} else {
		gl_FragColor = vec4(0,0,0,1);
	}
	return;

}