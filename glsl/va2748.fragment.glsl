#ifdef GL_ES
precision mediump float;
#endif

//Some sort of flower...

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0 - 0.625;
	p.y -= 0.2;

	vec2 t = p;
	t.x += sin(time)/45.0;
	float f = step(sqrt(t.x*t.x - t.y*t.y*t.y), 0.1);
	f *= step(length(t), 0.3);
	
	float s = smoothstep(0.0, abs(p.x+sin(p.y*9.0 + time)/45.0), 0.01);
	
	
	vec2 m = p;
	m.y += time/9.0;
	m.x -= cos(m.y*9.0)/45.0 - 0.05;
	m = mod(m, vec2(9.0, 0.2)) - 0.05;
	s += step(length(m), 0.05 - abs(m.y/2.0));
	
	s *= step(p.y, -f);

	gl_FragColor = vec4(f, s, 0.0, 1.0);

}