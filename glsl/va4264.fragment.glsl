#ifdef GL_ES
precision mediump float;
#endif

// Forked by rafacacique - https://twitter.com/rafacacique
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.1415;
const float TWOPI = 2.0*PI;

void main( void ) {
	vec2 uPos = ( gl_FragCoord.xy / resolution.y );
	float aspect = resolution.x/resolution.y;
	float multiplier = 0.005;
	const float fstep = 0.005;
	const float loop = 500.0;
	const float timeScale = 0.075;
	
	vec3 b = vec3(0.0);
	float amp = 1.0, decay = 0.0025;
	float hitFactor = 0.0;
	float tHit = 0.0;
	float ground = 0.1;
	float absSinTime = abs(sin(time));
	for (float i = 1.0; i <= loop; i++) {
		float t = time*timeScale - fstep*i*0.1;
		//t = mouse.x*10.0*timeScale - fstep*i*0.1;
		//t = 19.919-fstep*(i)*0.1;
		
		float x = aspect*(0.5 + 0.5*cos(10.0*t));
		vec2 point = vec2(x, amp*abs(sin(aspect*4.2*x))*0.5 + ground);
		
		float dx = (uPos.x - point.x);
		float dy = (uPos.y - point.y);
		float c = multiplier/(dx*dx + dy*dy)/(i*0.75);
		b += vec3(c*1.333, c*0.333*absSinTime, c*absSinTime*0.1);
		
		amp -= decay;
		
		if (i == 1.0) {
			hitFactor = float(abs(point.y - ground) < 0.1);
			tHit = t;
		}
	}

	float x = aspect*(0.5 + 0.5*cos(10.0*tHit));
	vec2 point = vec2(x, ground);

	// distance from "impact point"
	float d = 2.0*sqrt((uPos.x-point.x)*(uPos.x-point.x) + (uPos.y-point.y)*(uPos.y-point.y));
	
	// calculates bg color	
	float t0 = time*timeScale;
	float x0 = aspect*(0.5 + 0.5*cos(10.0*t0));
	float y0 = amp*abs(sin(aspect*4.2*x))*0.5 + ground;
			       
	// generator for the background pattern
	float c = abs(sin(3.0*uPos.x*gl_FragCoord.y+1.5*time));
	
	vec3 c0 = c*vec3(1.0, 1.0, 0.0);
	vec3 c1 = c*vec3(0.0, 0.0, 1.0);
	float s = (y0-ground)/amp;
	vec3 bgShade = mix(c0, c1, s);
			       
	float angle = (atan(point.y, point.x)+PI) / TWOPI;
	
	float ripple = 20.0*abs(sin(pow(d, 0.1)*300.0 - time*10.0) )/2.2;
	ripple *= abs(sin(pow(d, 0.1)*500.0 + time + 100.0) )/2.2;	
	ripple *= abs(sin(angle*PI*50.0 - time*5.0))/2.2;
	ripple *= abs(sin(angle*PI*100.0 + time*5.0))/2.2;
	ripple *= hitFactor;
			       
	vec3 color = d * vec3(ripple/(10.0*d), ripple/(20.0*d), ripple/(30.0*d));
	color *= b;
	color *= 200.0;
	color += b + (0.7-d) * bgShade;
	
	gl_FragColor = vec4(color, 1.0);
}