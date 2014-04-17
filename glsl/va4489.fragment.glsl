//Micael Pedrosa
//multi-particle (in and out wave)
//44 multi-particle system is used to build a virtual particle !

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;

uniform vec2 resolution;
const float zoom_out = 600.0;

vec2 p, m;

void screen(void) {
	float aspect = resolution.x/resolution.y; //uniform !!
	
	p = (gl_FragCoord.xy/resolution.xy) - 0.5;
	p.x *= aspect;
	p *= zoom_out;
	
	m = (mouse - 0.5);
	m.x *=aspect;
	m *=zoom_out;
}

float particle(float x, float y, float freq, float fase, float pulse) {
	vec2 c = p - vec2(x, y);
   	float l = length(c);
	float w = l*freq;
	
	return (sin(w + fase+pulse) + sin(w - pulse))/l;
}

void main(void) {
	screen();
	
	float color = 0.0;
	
	//color += particle(0.0, 0.0, .3, 3.1415, 6.0*time);
	color += particle(m.x, m.y, .3, 3.1415, 2.0*time);
	
	/*for(float i=0.0; i<44.0; i++)
	   color += particle(50.0*sin(i), 50.0*cos(i), .3, i, 3.0*time);
	
	for(float i=44.0; i<88.0; i++)
	   color += particle(50.0*sin(i), 50.0*cos(i), .3, -i, -3.0*time);
	*/
	
	for(float i=0.0; i<44.0; i++)
	   color += particle(50.0*sin(i) + 110.0*sin(time + 3.1415), 50.0*cos(i) + 110.0*cos(time + 3.1415), .3, 0.0, 2.0*time);
	
	for(float i=0.0; i<44.0; i++)
	   color += particle(50.0*sin(i) + 110.0*sin(time), 50.0*cos(i) + 110.0*cos(time), .3, 3.1415, 2.0*time);
	
	color *= 10.0;
	gl_FragColor = vec4(-color, color, 0.0, 1.0);
}