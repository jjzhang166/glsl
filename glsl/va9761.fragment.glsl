#ifdef GL_ES
precision highp float;
#endif

uniform float time; 
uniform vec2 resolution;
const float PI = 3.14159265358979323846264;

vec2 toCycles(vec2 cart) {
	float r = sqrt(cart.x*cart.x + cart.y*cart.y);
	float alpha = atan(cart.x, cart.y);
	if (cart.x<0.0)
		alpha +=2.0*PI;
	return vec2(r, alpha/(2.0*PI));
}


void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.y * 2.0 ) - vec2(1.75, 1.0);
	vec2 p = toCycles(position);
	float minute   = 60.0;
	float hour     = 60.0 * minute;
	float meridiem = 12.0 * hour;
	float day      = 2.0 * meridiem;
  float color;
	if (p.x > 1.0)
		color = 0.0;
	else if (p.x > 0.99)   //rim
		color = 1.0;
	else if (p.x > 0.80)   // second hand
		color = abs(mod(time, minute)-(p.y*minute))<0.5?1.0:0.0;
	else if (p.x > 0.60)	 // minute hand	  
		color = abs(mod(time, hour)-(p.y*hour))<0.5*minute?1.0:0.0;
	else if (p.x > 0.35)	 // hour hand	  
		color = abs(mod(time, meridiem)-(p.y*meridiem))<0.5*hour?1.0:0.0;  
	else                   // meridiem hand
	color = abs(mod(time, day)-(p.y*day))<0.5*meridiem?1.0:0.0;

	gl_FragColor = vec4( vec3(color), 1.0);
}
