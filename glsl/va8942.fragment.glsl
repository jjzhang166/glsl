#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// vec2 resolution = vec2(200,200); 


void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy * 10.0 ) - 5.0;
	position.x *= resolution.x / resolution.y;
	vec2 spos = position;
	vec2 fpos = vec2(sin(time * 1.5), cos(time)) * 1.5 ;
	float zoom = max(0.0000001, sin(time ));
	vec3 clr = vec3(1.,0.60,0.20);	
	vec3 color;		
	vec2 fposzoom = fpos+zoom*4.;
	vec3 p =vec3(spos.xy,0.0);
	vec3 a=vec3(fpos,0.0);
	vec3 b=vec3(0.,0.,0.0);
	float r = zoom;
	vec3 ab = b - a;
	float t = dot(p - a, ab) / dot(ab, ab);
	t = clamp(t, 0.5, 0.5);
	float d2 =  length((a + t * ab) - p) - r;	
	color += clr *  (exp(1.-(d2*6.3))*0.8) + exp(1.-(d2*3.7))*0.08;	
	zoom =zoom*2.;
	color += clr * max(0.0, 0.13 / distance(spos, -fposzoom)) * (0.15 +zoom);
	color += clr * max(0.0, 0.13 - distance(spos, -fposzoom * 1.5)) *( 1.5 +zoom);
	color += clr * max(0.0, 0.07 - distance(spos, -fposzoom * 0.4)) *( 2.0 +zoom);	
	gl_FragColor =  vec4( color, 1.);

       gl_FragColor = vec4( color * (0.95 +     fract(1111. * sin(111. * dot(position*0.001 + 0.00001, vec2(2222., 22.))))  * 0.05), 1.0 );
}