#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

// 2PI
#define COLOR_WIDTH 6.283185307179586
#define BRIGHTNESS -0.3
#define CONTRAST 1.5
float colorBand(float x, float start, float width) {
	return (cos(x * width + start) / 2. + 0.5 + BRIGHTNESS) * CONTRAST;
}

vec3 spectrum(float x) {
	x*= COLOR_WIDTH * mouse.x-mouse.y;
	float r = colorBand(x, 2.0943951023931953, COLOR_WIDTH); // 2PI/3
	float g = colorBand(x, 3.141592653589793, COLOR_WIDTH); // PI
	float b = colorBand(x, 4.1887902047863905, COLOR_WIDTH); // 4PI/3
	return vec3(r, g, b);
}

// FaerieLights => kinglesthecat.tumblr.com
// Parent => suspended illumination by kapsy1312.tumblr.com

void main( void ) {
    
    float sum = .5;
    float size = resolution.x / 1.6;
    float g = .85;
    int num = 60;
	
	float t = time/0.9;
	
    for (int i = 0; i < 32; ++i) {
        vec2 position = resolution / 2.0;
        position.x += sin(t / 1.0 + 1.0 * float(i)) * resolution.x * 0.25 * (mouse.x);
        position.y += sin(t / 1.0 + (1.0 + sin(t) * 0.2) * float(i)) * resolution.y * 0.4 * (mouse.y);
        
        float dist = length(gl_FragCoord.xy - position);
        
        sum += size / pow(dist*10.0, g*0.999);
    }
    
    //vec4 color = vec4(0,0,1,1);
    float ksum = sum / float(num);
    float val = ksum * 1.3;
    vec4 color = vec4(spectrum(val+.25)*val, 1.);
    
    gl_FragColor = vec4(color);
}