#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Cmen.
// Some oldschool 1995 effect fell out.

void main( void ) {
	float t = time;
	vec2 p = -1.0 + 2.0 * ( gl_FragCoord.xy / resolution.xy );
	p.x *= resolution.x/resolution.y; // aspect ratio
  	
	//polar vector.
  	vec2 rA = vec2(0.25,atan(p.y,p.x));
  	
  	rA.x += sin(rA.y * 3.0 + time)
          * sin(rA.y * 4.0 + (time * 2.8));
  	
  	//projection onto cartesian coordinates.
      	vec2 proj = vec2(rA.x * cos(rA.y), rA.x * sin(rA.y));
	
  	float col = (abs(proj.x) > abs(p.x) && abs(proj.y) > abs(p.y)) ? 1.0 - abs(sin(proj.x + time)) : 0.2 + abs(sin(proj.x + time));
        
  	p.x += sin(time + rA.x) * 0.4;
  	p.y += sin(time * 0.4) * 0.2;

  	
  	float c = abs(sin(length(p) * 8.0 + t + (p.x * sin(p.y * 8.0 + time)))) * (sin(length(p) * 8.0 + time * 6.0)) * 1.0; 
  	float c2 = abs(sin(pow(length(p), -1.0) + t)) * abs(sin(proj.x + time)) * 0.7; 	
  	
  	// terrible colour scheme
  	vec3 rgb = vec3(mix(col*0.2,c2 * 0.5,0.5),mix(col,c * 0.2,2.2),mix(c2 * 0.5,c* 0.5,abs(sin(time))));
	rgb = mix(rgb, vec3(length(p) * 0.1), -1.0);
  	rgb = mix(rgb * 0.5, rgb.zyx * 0.5,0.5 + sin(time) * 0.5);
  	//rgb = vec3(c);
  	gl_FragColor = vec4( rgb, 1.0 );
}