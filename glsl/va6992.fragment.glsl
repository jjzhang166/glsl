#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
#define num 15

void main( void ) {

    float sum = 0.0;
    float size = 50.0;
    float g = 0.95;
    for (int i = 0; i < num; ++i) {
        vec2 position = resolution / 2.0;
        position.y = 0.5*float(i)*resolution.y / float(num) + 0.15*resolution.y;
	position.x += 0.3*resolution.x*sin(time - float(i));
	if (i > num / 2) {
         position.y += 0.2 *resolution.y;
	}
        float dist = length(gl_FragCoord.xy - position);
	if (i > num / 2) {
	   sum += size / pow(dist, g);
	} else {
	   
	   sum -= size / pow(dist, g);
	}
    }
    float glow = 2.0 + 0.8*sin(time);
    float val = sum / (glow*float(num)/g);
    if (val < 0.0) {		
        gl_FragColor = vec4(-val*0.9, -val*0.1, -val, 1);
    } else {
        gl_FragColor = vec4(val*0.9, val*0.9, val*0.5, 1);
    }
}