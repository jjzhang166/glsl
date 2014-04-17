#ifdef GL_ES
precision mediump float;
#endif

//Some sort of flower...

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = vec2( (gl_FragCoord.x - resolution.x*0.5)/resolution.y, gl_FragCoord.y / resolution.y - 0.5 ) * 5.0;
	
	if (dot(p,p) < 0.5 && abs(atan(p.y,p.x)) > abs(fract(time*2.6)-0.5)*1.7 ) {
		gl_FragColor = vec4(1.,1.,0.,1.);
	} else {
		float det = p.x;
		p.x = fract(p.x+50+time)-1;
		p *= 50;
	
		vec2 t = p;
		t.x += sin(time)/90.0;
		float f = step(sqrt(t.x*t.x - t.y*t.y*t.y), 0.1);
		f *= step(length(t), 0.3) * step(-det, 0.0);
		
		float s = step(abs(p.x+cos(p.y*37.0 + time)/45.0), 0.01);
		
		vec2 m = p;
		m.y += time/9.0;
		m.x -= cos(m.y*10.0)/45.0 - 0.05;
		m = mod(m, vec2(9.0, 0.2)) - 0.05;
		s += step(length(m), 0.05 - abs(m.y/2.0));
		
		s *= step(p.y, -f) * step(-det, -p.y*10.);
	
		gl_FragColor = vec4(f, s, 5.0, 1.0);
	}
}