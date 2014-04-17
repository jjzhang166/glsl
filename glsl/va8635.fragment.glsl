#ifdef GL_ES
precision mediump float;
#endif

// minor edits by phoe

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
    
    float sum = 1.0;
    float size = resolution.x / 2.0;
    float g = .99;
    for (int i = 0; i < 50; ++i) {
        vec3 position;
	position.xy = resolution.xy / 2.0;
        position.x += sin(time / 1.5 + float(i)) * resolution.x * (mouse.y*mouse.y/2.5);
        position.y += sin(time + (2.0 + sin(time) * 0.01) * float(i)) * resolution.y * mouse.x / 2.0;
	position.z += sin(time / 4.0) * 20.0;
	
	vec3 coord;
	coord.xy = gl_FragCoord.xy;
	coord.z = 0.0;
	vec3 pos3;
	pos3.xy = position.xy;
	pos3.z = position.z;

	float dist = length(coord - pos3);
        sum += size / pow(dist, g);
    }

    float val = sum / 110.0;
    vec4 color = vec4(val*0.6, val*0.4, val*0.5, 1);
    
    gl_FragColor = vec4(color);
}